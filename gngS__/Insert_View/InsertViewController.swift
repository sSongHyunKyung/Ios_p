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
    @IBOutlet weak var ThirdTextField: UITextField!
    
    @IBOutlet weak var manBtn: UIButton!
    @IBAction func manBtnAction(_ sender: Any) {

            manBtn.tag = 2
            manBtn.setImage(UIImage(named: "radio_on"), for: .normal)
            girlBtn.setImage(UIImage(named: "radio_off"), for: .normal)
            emps.Gender = 0
            //print("============\(emps.Gender)============")
    }
    
    @IBOutlet weak var girlBtn: UIButton!
    @IBAction func girlBtnAction(_ sender: Any) {
            girlBtn.tag = 1
            girlBtn.setImage(UIImage(named: "radio_on"), for: .normal)
            manBtn.setImage(UIImage(named: "radio_off"), for: .normal)
            emps.Gender = 1
           // print("============\(emps.Gender)============")

    }
    
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    @IBOutlet weak var megazineSwitch: UISwitch!
    @IBAction func megazineAction(_ sender: Any) {
        if megazineSwitch.isOn == true {
            emps.Megazine = 1
           // print(emps.Megazine)
        } else if megazineSwitch.isOn == false {
            emps.Megazine = 0
           // print(emps.Megazine)
        }
    }
    
    @IBOutlet weak var agreeBtn: UIButton!
    @IBAction func agreeBtnAction(_ sender: Any) {
        if agreeBtn.tag == 0 {
            agreeBtn.tag = 100
            agreeBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            emps.Agree = 1
           // print("\(emps.Agree)")

        } else if agreeBtn.tag == 100 {
            agreeBtn.tag = 0
            agreeBtn.setImage(UIImage(systemName: "square"), for: .normal)
            emps.Agree = 0
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
        let tel3 = ThirdTextField.text!
        let gender = emps.Gender
        let position = positionTextField.text!
        let team = teamTextField.text!
        let megazine = emps.Megazine
        let agree = emps.Agree
        let memo = memoTextView.text!
  
        //MARK: バリデーションチェック
        
        // _ID
        if id.isEmpty {
            let alert = UIAlertController(title: "", message: "アカウントを入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !isValidEmail(id: id) {
            let alert = UIAlertController(title: "", message: "メールの形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if DB.shared.selectEmployeeID(employeeID: id) != nil {
            let alert = UIAlertController(title: "", message: "他のメールのを入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        // _PW
        if Pw.isEmpty {
            let alert = UIAlertController(title: "", message: "パスワードを入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !isValidPassword(pwd: Pw) {
            let alert = UIAlertController(title: "", message: "メールの形で入力してください(ex:A!123456)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _PW RE
        if rePw.isEmpty {
            let alert = UIAlertController(title: "", message: "パスワードを確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if Pw != rePw {
            let alert = UIAlertController(title: "", message: "パスワードをもう一度確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //KANJI
        if kanji.isEmpty {
            let alert = UIAlertController(title: "", message: "名前を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !Kanji(kanji) {
            let alert = UIAlertController(title: "", message: "漢字の形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _KANA
        if kana.isEmpty {
            let alert = UIAlertController(title: "", message: "名前を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !Katakana(kana) {
            let alert = UIAlertController(title: "", message: "カナの形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _ENG
        if eng.isEmpty {
            let alert = UIAlertController(title: "", message: "名前を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !Eng(eng) {
            let alert = UIAlertController(title: "", message: "英語の形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _Tel
        if tel1.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if tel1.count > 4 {
            let alert = UIAlertController(title: "", message: "電話番号を確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if tel2.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if tel2.count > 4 {
            let alert = UIAlertController(title: "", message: "電話番号を確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if tel3.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if tel3.count > 4 {
            let alert = UIAlertController(title: "", message: "電話番号を確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _Gender
        if gender == 3 {
           // print("Gender:値========================\(gender)")
            let alert = UIAlertController(title: "", message: "性別を選択してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        // _Position
        if position.isEmpty {
            let alert = UIAlertController(title: "", message: "役職を選択してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _Team
        if team.isEmpty {
            let alert = UIAlertController(title: "", message: "所属を選択してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if agree != 1 {
            let alert = UIAlertController(title: "", message: "約款同意をしてください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // end バリデーションチェック

        let empI = emps
        empI.EmployeeId = id
        empI.EmployeePw = Pw
        empI.EmployeeKanji = kanji
        empI.EmployeeKana = kana
        empI.EmployeeEng = eng
        empI.Tel = "\(tel1)-\(tel2)-\(tel3)"
        empI.Gender = gender
        empI.Position = position
        empI.Team = team
        empI.Megazine = megazine
        empI.Agree = agree
        empI.Memo = memo
        if memo.isEmpty {
            empI.Memo = "なし"
        }
        
        //print("ID:\(id),PW:\(Pw),REPW:\(rePw),KANJI:\(kanji),KANA:\(kana),ENG:\(eng),TEL1:\(tel1),TEl2:\(tel2),TEl3:\(tel3),GENDER:\(gender),POSITION:\(position),TEMA:\(team),MAGAZINE:\(megazine),AGREE:\(agree),MEMO:\(memo)")
        
//        print("ID:\(empI.EmployeeId),PW:\(empI.EmployeePw)")
//        print("KANJI:\(empI.EmployeeKanji),KANA:\(empI.EmployeeKana),ENG:\(empI.EmployeeEng)")
//        print("TEl:\(empI.Tel),GENDER:\(empI.Gender)")
//        print("TEMA:\(empI.Team),POSITION:\(empI.Position)")
//        print("MAGAZINE:\(empI.Megazine),AGREE:\(empI.Agree),MEMO:\(empI.Memo)")
        
        //VC連結data移動
        guard let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController else {return}
        inputVc.empII = empI
        //closer呼ぶ
        inputVc.didSave = {
            //tabbarChagne
            self.tabBarController!.selectedIndex = 0
            //insertView 生成　self.ViewDidLoad()また始める
            self.loadView()
        }
        inputVc.modalPresentationStyle = .fullScreen
        self.present(inputVc, animated: true, completion: nil)
    }
    
    
    // MARK: Insertボタン２
    @IBOutlet weak var insertBtn2: UIButton!
    @IBAction func insertBtn2(_ sender: Any) {
        
        let id = idTextField.text!
        let Pw = pwTextField.text!
        let rePw = rePwTextField.text!
        let kanji = kanjiTextField.text!
        let kana = kanaTextField.text!
        let eng = engTextField.text!
        let tel1 = FirstTelTextField.text!
        let tel2 = SecondTelTextField.text!
        let tel3 = ThirdTextField.text!
        let gender = emps.Gender
        let position = positionTextField.text!
        let team = teamTextField.text!
        let megazine = emps.Megazine
        let agree = emps.Agree
        let memo = memoTextView.text!
  
        //MARK: バリデーションチェック２
        
        // _ID
        if id.isEmpty {
            let alert = UIAlertController(title: "", message: "アカウントを入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !isValidEmail(id: id) {
            let alert = UIAlertController(title: "", message: "メールの形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if DB.shared.selectEmployeeID(employeeID: id) != nil {
            let alert = UIAlertController(title: "", message: "他のメールのを入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        // _PW
        if Pw.isEmpty {
            let alert = UIAlertController(title: "", message: "パスワードを入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !isValidPassword(pwd: Pw) {
            let alert = UIAlertController(title: "", message: "メールの形で入力してください(ex:A!123456)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _PW RE
        if rePw.isEmpty {
            let alert = UIAlertController(title: "", message: "パスワードを確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if Pw != rePw {
            let alert = UIAlertController(title: "", message: "パスワードをもう一度確認してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //KANJI
        if kanji.isEmpty {
            let alert = UIAlertController(title: "", message: "名前(漢字)を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !Kanji(kanji) {
            let alert = UIAlertController(title: "", message: "漢字の形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _KANA
        if kana.isEmpty {
            let alert = UIAlertController(title: "", message: "名前(カナ)を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !Katakana(kana) {
            let alert = UIAlertController(title: "", message: "カナの形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _ENG
        if eng.isEmpty {
            let alert = UIAlertController(title: "", message: "名前(英語)を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !Eng(eng) {
            let alert = UIAlertController(title: "", message: "英語の形で入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _Tel
        if tel1.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if tel2.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if tel3.isEmpty {
            let alert = UIAlertController(title: "", message: "電話番号を入力ください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _Gender
        if gender == 3 {
          //  print("Gender:値========================\(gender)")
            let alert = UIAlertController(title: "", message: "性別を選択してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        // _Position
        if position.isEmpty {
            let alert = UIAlertController(title: "", message: "役職を選択してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // _Team
        if team.isEmpty {
            let alert = UIAlertController(title: "", message: "所属を選択してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if agree != 1 {
            let alert = UIAlertController(title: "", message: "約款同意をしてください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        // end バリデーションチェック
        let empI = emps
        empI.EmployeeId = id
        empI.EmployeePw = Pw
        empI.EmployeeKanji = kanji
        empI.EmployeeKana = kana
        empI.EmployeeEng = eng
        empI.Tel = "\(tel1)-\(tel2)-\(tel3)"
        empI.Gender = gender
        empI.Position = position
        empI.Team = team
        empI.Megazine = megazine
        empI.Agree = agree
        empI.Memo = memo
        if memo.isEmpty {
            empI.Memo = "なし"
        }
        
        guard let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController else {return}
        inputVc.empII = empI
        inputVc.didSave = {
            //tabbarChagne
            self.tabBarController!.selectedIndex = 0
            //insertView 生成　self.ViewDidLoad()また始める
            self.loadView()
        }
        inputVc.modalPresentationStyle = .fullScreen
        self.present(inputVc, animated: true, completion: nil)
    }
    //MARK: PickerView
    
    //pickerViewFieldAction
    @IBAction func posFieldAction(_ sender: Any) {
        posPicker.selectRow(posRow(code: positionTextField.text!), inComponent: 0, animated: true)
    }
    
    @IBAction func teamFieldAction(_ sender: Any) {
        teamPicker.selectRow(teamRow(code: teamTextField.text!), inComponent: 0, animated: false)
    }
    
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
    
    
    //MARK: 外関数
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
    //メール
    func isValidEmail(id: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: id)
    }
    // パスワード
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,24}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
    //漢字
    func Kanji(_ str: String) -> Bool {
        let regex = "^[\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}ぁ-ゔァ-ヴー]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    //カナ
    func Katakana(_ str: String) -> Bool {
        let regex = "^[ァ-ヾ]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    //英語
    func Eng(_ str: String) -> Bool {
        let regex = "^[a-zA-Z]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
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
        // 改行キーが入力された時に実行される処理。
        // キーボードを下げる。
        view.endEditing(true)
        // 改行コードは入力しない。
        return false
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
        if offsetY < 560 {
            insertBtn2.isHidden = true
        } else if offsetY > 562 {
            insertBtn2.isHidden = false
        }
    }
    
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength:Int = 0
        
        switch (textField.tag) {
        case 1: //ID
            maxLength = 30
        
        case 2: //PW
            maxLength = 30
            
        case 3: //REPW
            maxLength = 30
            
        case 4: //KANJI
            maxLength = 30
            
        case 5: //KANA
            maxLength = 30
            
        case 6: //ENG
            maxLength = 30
            
        case 7: //TEL1
            maxLength = 4
            
        case 8: //TEL2
            maxLength = 4
            
        case 9: //TEL3
            maxLength = 4
         
        default:
            break
        }
        
        let textFiledinPut = textField.text?.count ?? 0
        let stringNum = string.count
        
        return textFiledinPut + stringNum <= maxLength
    }
    
}



