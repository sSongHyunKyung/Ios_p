import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate
        idTextField?.delegate = self
        pwTextField?.delegate = self
        
        //DB
        DB.shared.createLoginTbl()
        DB.shared.createEmployeeTbl()
        DB.shared.createPosition()
        DB.shared.createTeam()
        
        DB.shared.insertLogin(login: DB.shared.loadCSV(fileName:"dataList2"))
        DB.shared.insertEmployee(employee: DB.shared.emploadCSV(fileName: "dataList2"))
        DB.shared.insertPosition(position: DB.shared.positionloadCSV(fileName: "positionList"))
        DB.shared.insertTeam(team: DB.shared.teamloadCSV(fileName: "teamList"))
        
        pwTextField?.isSecureTextEntry = true
        idTextField.returnKeyType = .next
        pwTextField.returnKeyType = .go

        //UserDefaults Read機能
        let obj = UserDefaults.standard
        if let id = obj.string(forKey: "selectedAccount") {
            self.idTextField.text = id
            let customPlist = "\(id).plist" //file name for the read data
            
            //Property List
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: plist)
            
            //事前に入力したデータがTextFieldに入った
            self.idTextField.text = data?["id"] as? String
            self.pwTextField.text = data?["pw"] as? String
        }

        

        //キーボード隠れる
        self.hideKeyboardWhenTappedAround()
    }
    
    var alerts:Alerts!
    
    //Outlet
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!

    //ログインボタン
    @IBAction func loginBtnAction(_ sender: Any) {
 
        // 1.ボタン押す
        // 1-1).入力値をもらう所
        let id = idTextField.text!
        let pw = pwTextField.text!
        // 1-2).DBの情報
        let dbPw = DB.shared.selectLogin(loginId: id)
        
         //UserDefaults機能
         let obj = UserDefaults.standard
         var savedAccountList = obj.array(forKey: "accountList") ?? [String]()
         savedAccountList.append(id)
         obj.set(id, forKey: "selectedAccount")
         obj.synchronize() //同期化
        
        let customPlist = "\(self.idTextField.text!).plist"
        //directory経路、アプリーの範囲、全体経路(true),directoryのみ(false)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        print(path)
        //plistfile作る
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        print(plist)
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
        //data set
        data.setValue(self.idTextField.text!, forKey: "id")
        data.setValue(self.pwTextField.text!, forKey: "pw")
        data.write(toFile: plist as String, atomically: true)
        
        //print("plist = \n\(plist)")
        
        //MARK: バリデーションチェック
        // 2.入力値確認
        // 2-1).IDが空いているのか
        if id.isEmpty {
            alerts = Alerts(viewController: self, msg: "アカウントを入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "アカウントを入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        // 2-2).IDが存在するのか
        if dbPw == nil {
            alerts = Alerts(viewController: self, msg: "パスワードを入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "存在しないIDです。 もう一度入力してください。", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        // 2-3).PWが空いているのか
        if pw.isEmpty {
            //Alerts().showAlert(viewController: self, msg: "パスワードを入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        // 2-4).このIDのPWがあってるか
        if pw != dbPw {
            alerts = Alerts(viewController: self, msg: "パスワードが間違っています。 もう一度入力してください。", buttonTitle: "OK", handler:  {(action) -> Void in})
           // Alerts().showAlert(viewController: self, msg: "パスワードが間違っています。 もう一度入力してください。", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        // 3).次に
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "listView")
        else { return }
        
        //最後のログインの時
        DB.shared.updateLogin(loginId: id)
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 改行キーが入力された時に実行される処理。
        if textField == idTextField {
            pwTextField.becomeFirstResponder()
        } else {
            pwTextField.resignFirstResponder()
            loginBtnAction(pwTextField.returnKeyType.self)//goBtnを押すたら次のパージで移動
        }
        return true
        // 改行コードは入力しない。
    }
    
    
    //文字制限
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Backspace
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }

        switch(textField.text) {
            case idTextField.text:
                let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_@-.") // 入力可能な文字
                guard string.rangeOfCharacter(from: allowedCharacters) != nil else { return false }
            break
            default:
                break
            }
            return true
        }
}
