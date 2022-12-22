import UIKit

class UpdateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    /*
     ・社員修正画面
     1)修正画面作成
     1-1) NUM(x),ID(x),KANJI(o),KANA(o),ENG(o),TEL(o),GENDER(radio_btn)(x),POSITION(UIpickerView)(o),TEAM(UIpickerView)(o),REGISTERDATE(x),MEGAZINE(UIswitch)(o),MEMO(o) LayOut作成, キーボード
     1-2) DB社員情報 LayOutに表示 empSelect
     
     2)修正機能実装
     2-1)ボタン押す
     2-2)入力値挿入
     2-3)バリデイションチェック
     2-4)ListViewControllerにupdateデータ表示
     　・update値をemployeeに入る
     　・updateQuery実行(DBに堂録)
     ・画面移動
     */
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 全てのテキストフィールドのデリゲートになる。
        for textField in textFields {
            textField.delegate = self
        }
        
        memoTextView.delegate = self
        // テキストフィールドとキーボード関連の処理について、通知センターの設定をする。
        setNotificationCenter()
        
        //PickerView関数実行
        picker()
        toolbars()
        
        labelView.layer.borderWidth = 0.3
        labelView.layer.borderColor = UIColor.gray.cgColor
        
        genderView.layer.borderWidth = 0.3
        genderView.layer.borderColor = UIColor.gray.cgColor
        
        switchView.layer.borderWidth = 0.3
        switchView.layer.borderColor = UIColor.gray.cgColor
        
        numTextField.text = emps.employeeNum
        numTextField.textColor = UIColor.gray
        numTextField.isEnabled = false //TextFieldの入力不可能
        
        idTextField.text = emps.employeeId
        idTextField.textColor = UIColor.gray
        idTextField.isEnabled = false
        
        kanjiTextField.text = emps.employeeKanji
        kanaTextField.text = emps.employeeKana
        engTextField.text = emps.employeeEng
        
        let tel = emps.tel.split(separator: "-")
        FirstTel.text = String(tel[0])
        SecondTel.text = String(tel[1])
        ThirdTel.text = String(tel[2])
        
        if emps.gender == 0 {
            self.manBtn.setImage(UIImage(named: "radio_on"), for: .normal)
        } else if emps.gender == 1 {
            self.girlBtn.setImage(UIImage(named: "radio_on"), for: .normal)
        }
        
        positionTextField.text = Change().returnPosition(code: emps.position)
        positionTextField.tintColor = .clear
        
        teamTextField.text = Change().returnTeam(code: emps.team)
        teamTextField.tintColor = .clear
        
        registerTextField.text = emps.registerDate
        registerTextField.textColor = UIColor.gray
        registerTextField.isEnabled = false
        
        if emps.megazine == 0 {
            self.megazineSwitch.isOn = false
        } else if emps.megazine == 1 {
            self.megazineSwitch.isOn = true
        }
        
        memoTextView.text = emps.memo

        self.hideKeyboardWhenTappedAround()
    }
    
    private var nowEditingField:UITextField!    // 編集中のUITextField
    private var offsetAdded:CGFloat?            // スクロール戻す時用
    
    var emps:Employee!
    var pos = DB.shared.selectPositionAll()
    var teams = DB.shared.selectTeamAll()
    var textToolbar:Toolbars!
    var textToolbar2:Toolbars!
    var textToolbar3:Toolbars!
    var viewToolbar:ViewTollbars!
    var alerts:Alerts!

    //MARK: OUTLET
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var genderView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet private var textFields: [UITextField]!
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var kanjiTextField: UITextField!
    @IBOutlet weak var kanaTextField: UITextField!
    @IBOutlet weak var engTextField: UITextField!
    @IBOutlet weak var FirstTel: UITextField!
    @IBOutlet weak var SecondTel: UITextField!
    @IBOutlet weak var ThirdTel: UITextField!
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var girlBtn: UIButton!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var registerTextField: UITextField!
    @IBOutlet weak var megazineSwitch: UISwitch!
    @IBOutlet weak var memoTextView: UITextView!
    
    
    //PickerView項目を選択しない時
    @IBAction func posFieldAction(_ sender: Any) {
        pickerPosition.selectRow(Change().posRow(code: positionTextField.text!), inComponent: 0, animated: true)
    }
    //PickerView項目を選択しない時
    @IBAction func teamFieldAction(_ sender: Any) {
        pickerTeam.selectRow(Change().teamRow(code: teamTextField.text!), inComponent: 0, animated: true)
    }
    
    //MARK: 修正ボタン
    //修正ボタン押すと
    @IBAction func updateBtn(_ sender: Any) {
        
        //update emps
        guard let empu = self.emps else { return } //nil解除
        
        //textfiled値 input
        var ukanji = kanjiTextField.text ?? ""
        var ukana = kanaTextField.text ?? ""
        var ueng = engTextField.text ?? ""
        var uTel1 = FirstTel.text ?? ""
        var uTel2 = SecondTel.text ?? ""
        var uTel3 = ThirdTel.text ?? ""
        var uposition = positionTextField.text ?? ""
        var uteam = teamTextField.text ?? ""
        var umegazine = emps.megazine
        var umemo = memoTextView.text ?? ""
        
        //MARK: バリデーションチェック
        //漢字入力確認
        if ukanji.isEmpty {
            alerts = Alerts(viewController: self, msg: "漢字を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "漢字を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //漢字型確認
        if Regex().Kanji(ukanji) == false {
            alerts = Alerts(viewController: self, msg: "漢字の形を入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "漢字の形を入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //カナ入力確認
        if ukana.isEmpty {
            alerts = Alerts(viewController: self, msg: "カナを入力ください", buttonTitle: "OK", handler:  {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "カナを入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //カナ型入力確認
        if Regex().Katakana(ukana) == false {
            alerts = Alerts(viewController: self, msg: "カナの形を入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "カナの形を入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //eng入力確認
        if ueng.isEmpty {
            alerts = Alerts(viewController: self, msg: "英語を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "英語を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //eng型入力確認
        if Regex().Eng(ueng) == false {
            alerts = Alerts(viewController: self, msg: "英語の形を入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "英語の形を入力してください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //電話番号入力確認
        if uTel1.isEmpty {
            alerts = Alerts(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //電話番号入力確認
        if uTel2.isEmpty {
            alerts = Alerts(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            //Alerts().showAlert(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        //電話番号入力確認
        if uTel3.isEmpty {
            alerts = Alerts(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
           //Alerts().showAlert(viewController: self, msg: "電話番号を入力ください", buttonTitle: "OK", handler: {(action) -> Void in})
            return
        }
        
        //update値をemployeeに入る
        empu.employeeKanji = ukanji
        empu.employeeKana = ukana
        empu.employeeEng = ueng
        empu.tel = ("\(uTel1)-\(uTel2)-\(uTel3)")
        empu.position = Change().returnPosition2(code: uposition)
        empu.team = Change().returnTeam2(code: uteam)
        empu.megazine = umegazine
        empu.memo = umemo
        
        //update実行
        DB.shared.updateEmployee(employee: empu)
        
        //画面に移動
        dismiss(animated: true)
    }
    
    //Xボタン
    @IBAction func extiBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    //MARK: PickerView
    //PickerView フォルパティ
    var posPicker:UIPickerView = UIPickerView()
    var teamPicker:UIPickerView = UIPickerView()
    var pickerPosition: PickerViews!
    var pickerTeam: PickerViews!
    
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
    func picker() {
        pickerPosition = PickerViews(items: self.pos, textField: positionTextField)
        pickerTeam = PickerViews(items: self.teams, textField: teamTextField)
    }
    
    //MARK: Tel,Memo Toolbars
    func toolbars() {
        
        textToolbar = Toolbars(textField: FirstTel)
        textToolbar2 = Toolbars(textField: SecondTel)
        textToolbar3 = Toolbars(textField: ThirdTel)
    
        viewToolbar = ViewTollbars(textView: memoTextView)
    
    }
    //MARK: switch値
    @IBAction func megzineAction(_ sender: Any) {
        
        if megazineSwitch.isOn == true {
            emps.megazine = 1
            //print(emps.Megazine)
        } else if megazineSwitch.isOn == false {
            emps.megazine = 0
            //print(emps.Megazine)
        }
    }

    //MARK: キーボード
    /// 編集中のテキストフィールド
    private var editingTextField: UITextField?
    private var editingTextView: UITextView?
    /// キーボードが登場する前のスクロール量
    private var lastOffsetY: CGFloat = 0.0
}
    
// MARK: - Extensions テキストフィールドとキーボード関連の処理
extension UpdateViewController {
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
extension UpdateViewController: UITextFieldDelegate,UITextViewDelegate {
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
            FirstTel.becomeFirstResponder()
        } else {
            FirstTel.resignFirstResponder()
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // テキストフィールドの編集が開始された時に実行される処理。
        // どのテキストフィールドが編集中か保存しておく。
        editingTextView = textView
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // テキストフィールドの編集が終了した時に実行される処理。
        // 編集中のテキストフィールドをnilにする。
        editingTextView = nil
    }
    
    
    //MARK: Textfield 文字制限
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //BackSpace機能
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        //文字制限//
        var maxLength:Int = 0
        
        switch (textField.text) {
        case kanjiTextField.text: //KANJI
            maxLength = 30
            break
        case kanaTextField.text: //KANA
            maxLength = 30
            break
        case engTextField.text: //ENG
            maxLength = 30
            break
        case FirstTel.text: //TEL1
            maxLength = 4
            let numChar = CharacterSet(charactersIn:"1234567890")
            guard string.rangeOfCharacter(from: numChar) != nil else { return false }
            break
        case SecondTel.text: //TEL2
            maxLength = 4
            let numChar = CharacterSet(charactersIn:"1234567890")
            guard string.rangeOfCharacter(from: numChar) != nil else { return false }
            break
        case ThirdTel.text: //TEL3
            maxLength = 4
            let numChar = CharacterSet(charactersIn:"1234567890")
            guard string.rangeOfCharacter(from: numChar) != nil else { return false }
            break
        default:
            break
        }
        let textFiledinPut = textField.text?.count ?? 0
        let stringNum = string.count
        return textFiledinPut + stringNum <= maxLength
    }
}



