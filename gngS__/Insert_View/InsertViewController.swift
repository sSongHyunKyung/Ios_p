import UIKit

class InsertViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    /*
     1.入力画面作成
     2.堂録ボタンを押すとき.
     　・TextFieldに入力値をempsに挿入
     　・バリデーションチェック
     　・内容確認で値渡す
     */
    //MARK: viewDidRoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scrollView.delegate = self
        /// キーボード関連
        // 全てのテキストフィールドのデリゲートになる。
        for textField in textFields {
            textField.delegate = self
        }
        memoTextView.delegate = self
        // テキストフィールドとキーボード関連の処理について、通知センターの設定をする。
        setNotificationCenter()
        /// キーボード関連終
        
        picker()
        toolbars()
        
        pwTextField.isSecureTextEntry = true
        rePwTextField.isSecureTextEntry = true
        
        titleView.layer.borderWidth = 0.3
        titleView.layer.borderColor = UIColor.gray.cgColor
        agreeView.layer.borderWidth = 0.3
        agreeView.layer.borderColor = UIColor.gray.cgColor
        genderView.layer.borderWidth = 0.3
        genderView.layer.borderColor = UIColor.gray.cgColor
        positionTextField.tintColor = .clear
        teamTextField.tintColor = .clear
        
        insertBtn2.isHidden = true
     
        self.hideKeyboardWhenTappedAround()
    }
    
    
    //MARK: 変数,OUTLET
    var emps = Employee()
    var pos = DB.shared.selectPositionAll()
    var teams = DB.shared.selectTeamAll()
    var alerts:Alerts!
    var textToolbar:Toolbars!
    var textToolbar2:Toolbars!
    var textToolbar3:Toolbars!
    var viewToolbar:ViewTollbars!
    
    //collection
    @IBOutlet private var textFields: [UITextField]!
    //view
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var agreeView: UIView!
    @IBOutlet weak var genderView: UIView!
    //Field
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var rePwTextField: UITextField!
    @IBOutlet weak var kanjiTextField: UITextField!
    @IBOutlet weak var kanaTextField: UITextField!
    @IBOutlet weak var engTextField: UITextField!
    @IBOutlet weak var FirstTelTextField: UITextField!
    @IBOutlet weak var SecondTelTextField: UITextField!
    @IBOutlet weak var ThirdTelTextField: UITextField!
    
    @IBOutlet weak var manBtn: UIButton!
    @IBAction func manBtnAction(_ sender: Any) {

            manBtn.tag = 2
            manBtn.setImage(UIImage(named: "radio_on"), for: .normal)
            girlBtn.setImage(UIImage(named: "radio_off"), for: .normal)
            emps.gender = 0
            //print("============\(emps.Gender)============")
    }
    
    @IBOutlet weak var girlBtn: UIButton!
    @IBAction func girlBtnAction(_ sender: Any) {
            girlBtn.tag = 1
            girlBtn.setImage(UIImage(named: "radio_on"), for: .normal)
            manBtn.setImage(UIImage(named: "radio_off"), for: .normal)
            emps.gender = 1
           // print("============\(emps.Gender)============")

    }
    
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    @IBOutlet weak var megazineSwitch: UISwitch!
    @IBAction func megazineAction(_ sender: Any) {
        if megazineSwitch.isOn == true {
            emps.megazine = 1
           // print(emps.Megazine)
        } else if megazineSwitch.isOn == false {
            emps.megazine = 0
           // print(emps.Megazine)
        }
    }
    
    @IBOutlet weak var agreeBtn: UIButton!
    @IBAction func agreeBtnAction(_ sender: Any) {
        if agreeBtn.tag == 0 {
            agreeBtn.tag = 100
            agreeBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            emps.agree = 1
           // print("\(emps.Agree)")

        } else if agreeBtn.tag == 100 {
            agreeBtn.tag = 0
            agreeBtn.setImage(UIImage(systemName: "square"), for: .normal)
            emps.agree = 0
          //  print("\(emps.Agree)")
        }
    }
        
    @IBOutlet weak var memoTextView: UITextView!
    
    //MARK: Insertボタン
    //insertボタン
    @IBAction func insertBtn1(_ sender: Any) {
        
        let id = idTextField.text!
        let Pw = pwTextField.text!
        let rePw = rePwTextField.text!
        let kanji = kanjiTextField.text!
        let kana = kanaTextField.text!
        let eng = engTextField.text!
        let tel1 = FirstTelTextField.text!
        let tel2 = SecondTelTextField.text!
        let tel3 = ThirdTelTextField.text!
        let gender = emps.gender
        let position = positionTextField.text!
        let team = teamTextField.text!
        let megazine = emps.megazine
        let agree = emps.agree
        let memo = memoTextView.text!
  
        //MARK: バリデーションチェック
        
        // ID入力確認
        if id.isEmpty {
            alerts = Alerts(viewController: self, msg: "アカウントを入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
           // Alerts().showAlert(viewController: self, msg: "アカウントを入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        // IDの正規式確認
        if !Regex().isValidEmail(id: id) {
            alerts = Alerts(viewController: self, msg: "メールの形で入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "メールの形で入力してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        // ID重複確認
        if DB.shared.selectEmployeeID(employeeID: id) != nil {
            alerts = Alerts(viewController: self, msg: "他のメールのを入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "他のメールのを入力してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        // PW入力確認
        if Pw.isEmpty {
            alerts = Alerts(viewController: self, msg: "パスワードを入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "パスワードを入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        // PWの正規式確認
        if !Regex().isValidPassword(pwd: Pw) {
            alerts = Alerts(viewController: self, msg: "パスワードの形で入力してください(ex:A!123456)", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "パスワードの形で入力してください(ex:A!123456)", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        // pwRE入力確認
        if rePw.isEmpty {
            alerts = Alerts(viewController: self, msg: "パスワードを確認してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "パスワードを確認してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        // PwとrePwを確認
        if Pw != rePw {
            alerts = Alerts(viewController: self, msg: "パスワードをもう一度確認してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "パスワードをもう一度確認してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        //KANJI入力確認
        if kanji.isEmpty {
            alerts = Alerts(viewController: self, msg: "名前を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "名前を入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        //KANJIの正規式確認
        if !Regex().Kanji(kanji) {
            alerts = Alerts(viewController: self, msg: "漢字の形で入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "漢字の形で入力してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        //KANA入力確認
        if kana.isEmpty {
            alerts = Alerts(viewController: self, msg: "名前を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "名前を入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        //KANAの正規式確認
        if !Regex().Katakana(kana) {
            alerts = Alerts(viewController: self, msg: "カナの形で入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
           // Alerts().showAlert(viewController: self, msg: "カナの形で入力してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        //ENG入力確認
        if eng.isEmpty {
            alerts = Alerts(viewController: self, msg: "名前を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "名前を入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        //ENGの正規式確認
        if !Regex().Eng(eng) {
            alerts = Alerts(viewController: self, msg: "英語の形で入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
           // Alerts().showAlert(viewController: self, msg: "英語の形で入力してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        // Tel入力確認
        if tel1.isEmpty {
           alerts = Alerts(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        // Tel入力確認
        if tel2.isEmpty {
            alerts = Alerts(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        // Tel入力確認
        if tel3.isEmpty {
            alerts = Alerts(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        // Gender入力確認
        if gender == 3 {
            alerts = Alerts(viewController: self, msg: "性別を選択してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "性別を選択してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        // Position入力確認
        if position.isEmpty {
            alerts = Alerts(viewController: self, msg: "役職を選択してください", buttonTitle: "OK", handler: {(action) -> Void in})
           // Alerts().showAlert(viewController: self, msg: "役職を選択してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        // Team入力確認
        if team.isEmpty {
            alerts = Alerts(viewController: self, msg: "所属を選択してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "所属を選択してください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        
        // agreeチェック確認
        if agree != 1 {
            alerts = Alerts(viewController: self, msg: "約款同意をしてください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "約款同意をしてください", buttonTitle: "OK", handler:{(action) -> Void in})
            return
        }
        // end バリデーションチェック

        let empI = emps
        empI.employeeId = id
        empI.employeePw = Pw
        empI.employeeKanji = kanji
        empI.employeeKana = kana
        empI.employeeEng = eng
        empI.tel = "\(tel1)-\(tel2)-\(tel3)"
        empI.gender = gender
        empI.position = position
        empI.team = team
        empI.megazine = megazine
        empI.agree = agree
        empI.memo = memo
        if memo.isEmpty {
            empI.memo = "なし"
        }
        
        //VC連結data移動
        guard let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController else {return}
        inputVc.empII = empI
        //closer呼ぶ
        inputVc.didSave = {
            //tabbarChagne
            self.tabBarController!.selectedIndex = 0
            //insertView 生成　self.ViewDidLoad()また始める
            self.idTextField.text = ""
            self.pwTextField.text = ""
            self.rePwTextField.text = ""
            self.kanjiTextField.text = ""
            self.kanaTextField.text = ""
            self.engTextField.text = ""
            self.FirstTelTextField.text = ""
            self.SecondTelTextField.text = ""
            self.ThirdTelTextField.text = ""
            self.girlBtn.setImage(UIImage(named: "radio_off"), for: .normal)
            self.manBtn.setImage(UIImage(named: "radio_off"), for: .normal)
            self.positionTextField.text = ""
            self.teamTextField.text = ""
            self.megazineSwitch.isOn = false
            self.agreeBtn.setImage(UIImage(systemName: "square"), for: .normal)
            self.memoTextView.text = ""
            self.scrollView.contentOffset.y = 0
        }
        inputVc.modalPresentationStyle = .fullScreen
        self.present(inputVc, animated: true, completion: nil)
    }
    
    //insertBtn2
    @IBOutlet weak var insertBtn2: UIButton!
    
    //MARK: PickerView
    
    //pickerViewFieldAction
    @IBAction func posFieldAction(_ sender: Any) {
        pickerPosition.selectRow(Change().posRow(code: positionTextField.text!), inComponent: 0, animated: true)
    }
    
    @IBAction func teamFieldAction(_ sender: Any) {
        pickerTeam.selectRow(Change().teamRow(code: teamTextField.text!), inComponent: 0, animated: false)
    }
    
    //PickerView フォルパティ
    var posPicker:UIPickerView = UIPickerView()
    var teamPicker:UIPickerView = UIPickerView()
    var pickerPosition:PickerViews!
    var pickerTeam:PickerViews!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return pos.count
        case 2:
            return teams.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return pos[row].name
        case 2:
            return teams[row].name
        default:
            return "EEROR"
        }
    }
        
    //pickerView 設定 (pickerView + toolbar)
    func picker() {
        pickerPosition = PickerViews(items: self.pos, textField: positionTextField)
        pickerTeam = PickerViews(items: self.teams, textField: teamTextField)
    }
    
    //MARK: Toolbars
    func toolbars() {
        textToolbar = Toolbars(textField: FirstTelTextField)
        textToolbar2 = Toolbars(textField: SecondTelTextField)
        textToolbar3 = Toolbars(textField: ThirdTelTextField)
        
        viewToolbar = ViewTollbars(textView: memoTextView)
    }
    

    //MARK: キーボード
    /// 編集中のテキストフィールド
    private var editingTextField: UITextField?
    private var editingTextView: UITextView?
    /// キーボードが登場する前のスクロール量
    private var lastOffsetY: CGFloat = 0.0
}

// MARK: - Extensions テキストフィールドとキーボード関連の処理
extension InsertViewController {
    /// テキストフィールドとキーボード関連の処理について、通知センターの設定をする。
    private func setNotificationCenter() {
        /// デフォルトの通知センターを取得
        let notification = NotificationCenter.default

        // キーボードのframeが変化した時のイベントハンドラーを登録する。
        notification.addObserver(self, selector: #selector(keyboardChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(keyboardChangeFrame2(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)

        // キーボードが登場する時のイベントハンドラーを登録する。
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // キーボードが退場する時のイベントハンドラーを登録する。
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// キーボードのサイズが変化すると実行されるイベントハンドラー
    /// テキストフィールドが隠れたならスクロールする。
    ///
    /// キーボードの退場でも同じイベントが発生するので、編集中のテキストフィールドがnilの時は処理を中断する。
    @objc private func keyboardChangeFrame(_ notification: Notification) {
        // 編集中のテキストフィールドがnilの時は処理を中断する。
        guard let textField = editingTextField else { return }
        
        // キーボードのframeを調べる。
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        // テキストフィールドのframeをキーボードと同じウィンドウの座標系にする。
        guard let textFieldFrame = view.window?.convert(textField.frame, from: textField.superview) else {
            return
        }

        /// テキストフィールドとキーボードの間の余白(自由に変更してください。)
        let spaceBetweenTextFieldAndKeyboard: CGFloat = 8

        // 編集中のテキストフィールドがキーボードと重なっていないか調べる。
        // 重なり = (テキストフィールドの下端 + 余白) - キーボードの上端
        var overlap = (textFieldFrame.maxY + spaceBetweenTextFieldAndKeyboard) - keyboardFrame.minY
        if overlap > 0 {
            // 重なっている場合、キーボードが隠れている分だけスクロールする。
            overlap = overlap + scrollView.contentOffset.y
            scrollView.setContentOffset(CGPoint(x: 0, y: overlap), animated: true)
        }
    }

    /// キーボードの退場でも同じイベントが発生するので、編集中のテキストフィールドがnilの時は処理を中断する。
    @objc private func keyboardChangeFrame2(_ notification: Notification) {
        // 編集中のテキストフィールドがnilの時は処理を中断する。
        guard let textView = editingTextView else { return }

        // キーボードのframeを調べる。
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        // テキストフィールドのframeをキーボードと同じウィンドウの座標系にする。
        guard let textViewFrame = view.window?.convert(textView.frame, from: textView.superview) else {
            return
        }

        /// テキストフィールドとキーボードの間の余白(自由に変更してください。)
        let spaceBetweenTextViewAndKeyboard: CGFloat = 8

        // 編集中のテキストフィールドがキーボードと重なっていないか調べる。
        // 重なり = (テキストフィールドの下端 + 余白) - キーボードの上端
        
        var overlap2 = (textViewFrame.maxY + spaceBetweenTextViewAndKeyboard) - keyboardFrame.minY
        if overlap2 > 0 {
            // 重なっている場合、キーボードが隠れている分だけスクロールする。
            overlap2 = overlap2 + scrollView.contentOffset.y
            scrollView.setContentOffset(CGPoint(x: 0, y: overlap2), animated: true)
        }
    }
    
    
    
    /// キーボードが登場する通知を受けると実行されるイベントハンドラー
    @objc private func keyboardWillShow(_ notification: Notification) {
        // キーボードが登場する前のスクロール量を保存しておく。
        lastOffsetY = scrollView.contentOffset.y
    }

    /// キーボードが退場する通知を受けると実行されるイベントハンドラー
    @objc private func keyboardWillHide(_ notification: Notification) {
        // スクロール量をキーボードが登場する前の位置に戻す。
        scrollView.setContentOffset(CGPoint(x: 0, y: lastOffsetY), animated: true)
    }
}

// MARK: - Extensions UITextFieldDelegate テキストフィールドとキーボード関連の処理
extension InsertViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // テキストフィールドの編集が開始された時に実行される処理。
        // どのテキストフィールドが編集中か保存しておく。
        editingTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // テキストフィールドの編集が終了した時に実行される処理。
        // 編集中のテキストフィールドをnilにする。
        editingTextField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == idTextField {
            pwTextField.becomeFirstResponder()
        } else {
            pwTextField.resignFirstResponder()
        }
        
        if textField == pwTextField {
            rePwTextField.becomeFirstResponder()
        } else {
            rePwTextField.resignFirstResponder()
        }
       
        if textField == rePwTextField {
            kanjiTextField.becomeFirstResponder()
        } else {
            kanjiTextField.resignFirstResponder()
        }
        
        if textField == kanjiTextField {
            kanaTextField.becomeFirstResponder()
        } else {
            kanaTextField.resignFirstResponder()
        }
        
        if textField == kanaTextField {
            engTextField.becomeFirstResponder()
        } else {
            engTextField.resignFirstResponder()
        }
        
        if textField == engTextField {
            FirstTelTextField.becomeFirstResponder()
        } else {
            FirstTelTextField.resignFirstResponder()
        }
        return true
    }
}
extension InsertViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // テキストviewの編集が開始された時に実行される処理。
        // どのテキストviewが編集中か保存しておく。
        editingTextView = textView
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // テキストviewの編集が終了した時に実行される処理。
        // 編集中のテキストviewドをnilにする。
        editingTextView = nil
    }
}

extension InsertViewController: UIScrollViewDelegate {
    
    // Scrollをする時
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        let offsetY = scrollView.contentOffset.y
//        print("====offsetY===========\(offsetY)===============")
//        let scrollHeight = scrollView.contentSize.height
//        print("====scrollHeight===========\(scrollHeight)==============")
//        let screenHeight = scrollView.bounds.size.height
//        print("====screenHeight============\(screenHeight)===============")
//        let length = scrollHeight - screenHeight
//        print("=============length==============\(length)======================")
        if offsetY < 370 {
            insertBtn2.isHidden = true
        } else if offsetY > 369 {
            insertBtn2.isHidden = false
        }
    }
    
        
    //MARK: TextField制限
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //BackSpace機能
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        //英語,数字,@,-,_,.のみ入力 or Tel= 数字のみ//
        //TextField Length制限
        var maxLength:Int = 0
        
        switch (textField.text) {
        case idTextField.text: //ID
            maxLength = 30
            let allowedCharacters = CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_@-.") // 入力可能な文字
            guard string.rangeOfCharacter(from: allowedCharacters) != nil else { return false }
            break
        case pwTextField.text: //PW
            maxLength = 30
            break
        case rePwTextField.text: //REPW
            maxLength = 30
            break
        case kanjiTextField.text: //KANJI
            maxLength = 30
            break
        case kanaTextField.text: //KANA
            maxLength = 30
            break
        case engTextField.text: //ENG
            maxLength = 30
            break
        case FirstTelTextField.text: //TEL1
            maxLength = 4
            let numChar = CharacterSet(charactersIn:"1234567890").inverted
            guard string.rangeOfCharacter(from: numChar) == nil else { return false }
            break
        case SecondTelTextField.text: //TEL2
            maxLength = 4
            let numChar = CharacterSet(charactersIn:"1234567890").inverted
            guard string.rangeOfCharacter(from: numChar) == nil else { return false }
            break
        case ThirdTelTextField.text: //TEL3
            maxLength = 4
            let numChar = CharacterSet(charactersIn:"1234567890").inverted
            guard string.rangeOfCharacter(from: numChar) == nil else { return false }
            break
        default:
            break
        }
        
        //Length
        let textFiledinPut = textField.text?.count ?? 0
        let stringNum = string.count
        return textFiledinPut + stringNum <= maxLength
    }
    
}
