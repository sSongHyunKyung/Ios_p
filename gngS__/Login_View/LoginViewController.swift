import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        idTextField.delegate = self
        pwTextField.delegate = self
        
        
        DB.shared.createLoginTbl()
        DB.shared.createEmployeeTbl()
        DB.shared.createPosition()
        DB.shared.createTeam()
        
        DB.shared.insertLogin(login: DB.shared.loadCSV(fileName:"dataList2"))
        DB.shared.insertEmployee(employee: DB.shared.emploadCSV(fileName: "dataList2"))
        DB.shared.insertPosition(position: DB.shared.positionloadCSV(fileName: "positionList"))
        DB.shared.insertTeam(team: DB.shared.teamloadCSV(fileName: "teamList"))
        
        pwTextField.isSecureTextEntry = true
        
        //キーボード隠れる
        self.hideKeyboardWhenTappedAround()
        //キーボードターゲト
        //idTextField.addTarget(self, action: #selector(didEndonExit), for: UIControl.Event.editingDidEndOnExit)
        //pwTextField.addTarget(self, action: #selector(didEndonExit), for: UIControl.Event.editingDidEndOnExit)
    }
    //ブタンを押したら入力ポイント起こすと完了はキーボード下がる
    //    @objc func didEndonExit(_ sender: UITextField) {
    //        if idTextField.isFirstResponder {
    //            pwTextField.becomeFirstResponder()
    //        }
    //    }
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    
    @IBAction func loginBtnAction(_ sender: Any) {
        // 1.ボタン押す
        // 1-1).入力値をもらう所
        let id = idTextField.text!
        let pw = pwTextField.text!
        // 1-2).DBの情報
        let dbPw = DB.shared.selectLogin(loginId: id)
        
        //MARK: バリデーションチェック
        // 2.入力値確認
        // 2-1).IDが空いているのか
        if id.isEmpty {
            let alert = UIAlertController(title: "", message: "アカウントを入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        // 2-2).IDが存在するのか
        if dbPw == nil {
            let alert = UIAlertController(title: "", message: "存在しないIDです。 もう一度入力してください。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        // 2-3).PWが空いているのか
        if pw.isEmpty {
            let alert = UIAlertController(title: "", message: "パスワードを入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        // 2-4).このIDのPWがあってるか
        if pw != dbPw {
            let alert = UIAlertController(title: "", message: "パスワードが間違っています。 もう一度入力してください。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
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
        // キーボードを下げる。
        view.endEditing(true)
        // 改行コードは入力しない。
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        if ((idTextField.text?.isEmpty) == nil) {
        //            return true
        //         }
        //        let charSetExceptNumber = CharacterSet.decimalDigits.inverted
        //        let strComponents = string.components(separatedBy: charSetExceptNumber)
        //        let numberFiltered = strComponents.joined(separator: "")
        //
        //        return string == numberFiltered
        //guard textField.text!.count < 5 else { return false }
                    
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
            
        case pwTextField.text:
            let allowedCharacters = CharacterSet(charactersIn:"") // 入力可能な文字
            guard string.rangeOfCharacter(from: allowedCharacters) == nil else { return false }
            
            default:
                break
            }
            return true
        }
}

    

// キーボーと　隠れる
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        //他の面をTAP
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


