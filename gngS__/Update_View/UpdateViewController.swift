import UIKit

class UpdateViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        labelView.layer.borderWidth = 0.3
        labelView.layer.borderColor = UIColor.gray.cgColor
        
        genderView.layer.borderWidth = 0.3
        genderView.layer.borderColor = UIColor.gray.cgColor
        
        switchView.layer.borderWidth = 0.3
        switchView.layer.borderColor = UIColor.gray.cgColor
        
        numTextField.text = emps.EmployeeNum
        numTextField.textColor = UIColor.gray
        numTextField.isEnabled = false //TextFieldの入力不可能
        
        idTextField.text = emps.EmployeeId
        idTextField.textColor = UIColor.gray
        idTextField.isEnabled = false
        
        kanjiTextField.text = emps.EmployeeKanji
        kanaTextField.text = emps.EmployeeKana
        engTextField.text = emps.EmployeeEng
        
        let tel = emps.Tel.split(separator: "-")
        FirstTel.text = String(tel[0])
        SecondTel.text = String(tel[1])
        ThirdTel.text = String(tel[2])
        
        if emps.Gender == 0 {
            self.manBtn.setImage(UIImage(named: "radio_on"), for: .normal)
        } else if emps.Gender == 1 {
            self.girlBtn.setImage(UIImage(named: "radio_on"), for: .normal)
        }
        
        positionTextField.text = returnPosition(code: emps.Position)
        positionTextField.tintColor = .clear
        
        teamTextField.text = returnTeam(code: emps.Team)
        teamTextField.tintColor = .clear
        
        
        registerTextField.text = emps.RegisterDate
        registerTextField.textColor = UIColor.gray
        registerTextField.isEnabled = false
        
        if emps.Megazine == 0 {
            self.megazineSwitch.isOn = false
        } else if emps.Megazine == 1 {
            self.megazineSwitch.isOn = true
        }
        
        memoTextView.text = emps.Memo
        
        
        self.hideKeyboardWhenTappedAround()
        
    }

    
    private var nowEditingField:UITextField!    // 編集中のUITextField
    private var offsetAdded:CGFloat?            // スクロール戻す時用
    
    var emps:Employee!
    var pos = DB.shared.selectPositionAll()
    var teams = DB.shared.selectTeamAll()
    
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
    
    
    @IBAction func posFieldAction(_ sender: Any) {
        posPicker.selectRow(posRow(code: positionTextField.text!), inComponent: 0, animated: true)
    }
    
    @IBAction func teamFieldAction(_ sender: Any) {
        teamPicker.selectRow(teamRow(code: teamTextField.text!), inComponent: 0, animated: false)
    }
    
    
    
    //MARK: 修正ボタン
    //修正ボタン押すと
    @IBAction func updateBtn(_ sender: Any) {
        
        //update emps
        guard let empu = self.emps else { return } //nil解除
        
        //textfiled値 input
        var Ukanji = kanjiTextField.text ?? ""
        var Ukana = kanaTextField.text ?? ""
        var Ueng = engTextField.text ?? ""
        var UTel1 = FirstTel.text ?? ""
        var UTel2 = SecondTel.text ?? ""
        var UTel3 = ThirdTel.text ?? ""
        var Uposition = positionTextField.text ?? ""
        var Uteam = teamTextField.text ?? ""
        var Umegazine = emps.Megazine
        var Umemo = memoTextView.text ?? ""
        
        
        //MARK: バリデーションチェック
        if Ukanji.isEmpty {
            let alert = UIAlertController(title: "", message: "漢字を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if Kanji(Ukanji) == false {
            let alert = UIAlertController(title: "", message: "漢字の形を入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if Ukana.isEmpty {
            let alert = UIAlertController(title: "", message: "カナを入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if Katakana(Ukana) == false {
            let alert = UIAlertController(title: "", message: "カナの形を入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if Ueng.isEmpty {
            let alert = UIAlertController(title: "", message: "英語を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if Eng(Ueng) == false {
            let alert = UIAlertController(title: "", message: "英語の形を入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if UTel1.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if UTel1.count > 4 {
            let alert = UIAlertController(title: "", message: "電話番号を確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if UTel2.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if UTel2.count > 4 {
            let alert = UIAlertController(title: "", message: "電話番号を確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if UTel3.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if UTel3.count > 4 {
            let alert = UIAlertController(title: "", message: "電話番号を確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        //update値をemployeeに入る
        empu.EmployeeKanji = Ukanji
        empu.EmployeeKana = Ukana
        empu.EmployeeEng = Ueng
        empu.Tel = ("\(UTel1)-\(UTel2)-\(UTel3)")
        empu.Position = returnPosition2(code: Uposition)
        empu.Team = returnTeam2(code: Uteam)
        empu.Megazine = Umegazine
        empu.Memo = Umemo
        
        //update実行
        DB.shared.updateEmployee(employee: empu)
        
        //画面に移動
//        guard let returnVC = self.storyboard?.instantiateViewController(withIdentifier: "listView") else {return}
//        returnVC.modalPresentationStyle = .fullScreen
//        returnVC.modalTransitionStyle = .coverVertical
//        self.present(returnVC, animated: true)
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
            return pos[row].PositionName
        case 2:
            return teams[row].TeamName
        default:
            return "EEROR"
        }
    }
    
    //pickerView 設定 (pickerView + toolbar)
    func picker() {
        
        //posPicker = pickerView + textField
        posPicker.tag = 1
        posPicker.delegate = self
        posPicker.dataSource = self
        positionTextField.inputView = posPicker
        
        //teamPicker = pickerView + textField
        teamPicker.tag = 2
        teamPicker.delegate = self
        teamPicker.dataSource = self
        teamTextField.inputView = teamPicker
        // 選択行をハイライト
        posPicker.showsSelectionIndicator = true
        teamPicker.showsSelectionIndicator = true
        // 決定・キャンセル用ツールバーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title:"決定", style: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(title:"キャンセル", style: .done, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
        
        
        
        let toolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem2 = UIBarButtonItem(title:"決定", style: .done, target: self, action: #selector(done2))
        let cancelItem2 = UIBarButtonItem(title:"キャンセル", style: .done, target: self, action: #selector(cancel2))
        toolbar2.setItems([cancelItem2, spaceItem2, doneItem2], animated: true)
        
        
        let toolbar3 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem3 = UIBarButtonItem(title:"完了", style: .done, target: self, action: #selector(done3))
        toolbar3.setItems([spaceItem3, doneItem3], animated: true)
        
        // toolbar 実装
        positionTextField.inputAccessoryView = toolbar
        teamTextField.inputAccessoryView = toolbar2
        memoTextView.inputAccessoryView = toolbar3
    }
    
    // 決定ボタンのアクション指定
    @objc func done() {
        positionTextField.endEditing(true)
        positionTextField.text = "\(pos[posPicker.selectedRow(inComponent: 0)].PositionName)"
        //print("============\(pos[posPicker.selectedRow(inComponent: 0)].PositionName)=========")
    }
    // キャンセルボタンのアクション指定
    @objc func cancel(){
        positionTextField.endEditing(true)
        //print("-------------------\(positionTextField.text!)----------------------")
        
    }
    @objc func done2() {
        teamTextField.endEditing(true)
        teamTextField.text = "\(teams[teamPicker.selectedRow(inComponent: 0)].TeamName)"
        //print("\(teams[teamPicker.selectedRow(inComponent: 0)].TeamName)")
    }
    // キャンセルボタンのアクション指定
    @objc func cancel2(){
        teamTextField.endEditing(true)
        //print("-----------\(teamTextField.text!)---------------")
    }
    
    @objc func done3() {
        memoTextView.endEditing(true)
    }
    
    //MARK: change関数
    
    func returnPosition(code:String) -> String {
        for position in pos {
            if code == position.PositionCode {
                return position.PositionName
            }
        }
        return ""
    }
    
    func returnPosition2(code:String) -> String {
        for postion in pos {
            if code == postion.PositionName {
                return postion.PositionCode
            }
        }
        return ""
    }
    
    func returnTeam(code:String) -> String {
        for team in teams {
            if code == team.TeamCode {
                return team.TeamName
            }
        }
        return ""
    }
    
    func returnTeam2(code:String) -> String {
        for team in teams {
            if code == team.TeamName {
                return team.TeamCode
            }
        }
        return ""
    }
    
    func posRow(code:String) -> Int {
        var row:Int = 0
        
        if code == "社員" {
            row = 0
            return row
        } else if code == "主任" {
            row = 1
            return row
        } else if code == "課長" {
            row = 2
            return row
        } else if code == "次長" {
            row = 3
            return row
        } else if code == "部長" {
            row = 4
            return row
        } else if code == "代表" {
            row = 5
            return row
        }
        return row
    }
    
    func teamRow(code:String) -> Int {
        var rows:Int = 0
        if code == "第1チーム" {
            rows = 0
            return rows
        } else if code == "第2チーム" {
            rows = 1
            return rows
        } else if code == "第3チーム" {
            rows = 2
            return rows
        } else if code == "第4チーム" {
            rows = 3
            return rows
        }
        return rows
    }
    
    //MARK: 正規式
    func Katakana(_ str: String) -> Bool {
        let regex = "^[ァ-ヾ]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    
    func Kanji(_ str: String) -> Bool {
        let regex = "^[\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}ぁ-ゔァ-ヴー]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    
    func Eng(_ str: String) -> Bool {
        let regex = "^[a-zA-Z]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    
    //MARK: switch値
    @IBAction func megzineAction(_ sender: Any) {
        
        if megazineSwitch.isOn == true {
            emps.Megazine = 1
            //print(emps.Megazine)
        } else if megazineSwitch.isOn == false {
            emps.Megazine = 0
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
extension UpdateViewController: UITextFieldDelegate {
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
        // 改行キーが入力された時に実行される処理。
        // キーボードを下げる。
        view.endEditing(true)
        // 改行コードは入力しない。
        return false
    }
}
extension UpdateViewController: UITextViewDelegate {
    
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
    //Textfield 文字数制限
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength:Int = 0
        
        switch (textField.tag) {

        case 1: //KANJI
            maxLength = 30
            
        case 2: //KANA
            maxLength = 30
            
        case 3: //ENG
            maxLength = 30
            
        case 4: //TEL1
            maxLength = 4
            
        case 5: //TEL2
            maxLength = 4
            
        case 6: //TEL3
            maxLength = 4
         
        default:
            break
        }
        
        let textFiledinPut = textField.text?.count ?? 0
        let stringNum = string.count
        
        return textFiledinPut + stringNum <= maxLength
    }
    
    
    
}


