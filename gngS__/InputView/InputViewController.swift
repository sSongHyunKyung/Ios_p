import UIKit

class InputViewController: UIViewController {
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //labelに入る
        idLabel.text = empII.employeeId
        kanjiLabel.text = empII.employeeKanji
        kanaLabel.text = empII.employeeKana
        engLabel.text = empII.employeeEng
        telLabel.text = empII.tel
        positionLabel.text = empII.position
        teamLabel.text = empII.team
        genderLabel.text = returnGender(num: empII.gender)
        megazineLabel.text = returnMegazie(num: empII.megazine)
        agreeLabel.text = returnAgree(num: empII.agree)
        memoLabel.text = empII.memo
        
        //inputBtn1.addTarget(self, action: #selector(method), for: .touchUpInside)
        
        
    }
    //MARK: OUTLET
    var empII:Employee!
    var pos = DB.shared.selectPositionAll()
    var teams = DB.shared.selectTeamAll()
    //Label
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var kanjiLabel: UILabel!
    @IBOutlet weak var kanaLabel: UILabel!
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var megazineLabel: UILabel!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    //Btn
    @IBOutlet weak var inputBtn1: UIButton!
    @IBOutlet weak var intputBtn2: UIButton!
    
 
    //closer
    var didSave: (()->Void)?

    
    //MARK: inputBtn押す
    @IBAction func inputAction(_ sender: Any) {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let registerDate = dateFormatter.string(from: nowDate)

        guard let empF = self.empII else { return }
        let loginF = Login()
        
        empF.employeeNum = empII.employeeNum
        empF.employeeId = empII.employeeId
        empF.employeePw = empII.employeePw
        empF.employeeKanji = empII.employeeKanji
        empF.employeeKana = empII.employeeKana
        empF.employeeEng = empII.employeeEng
        empF.tel = empII.tel
        empF.gender = empII.gender
        empF.position = returnPosition2(code: empII.position)
        empF.team = returnTeam2(code: empII.team)
        empF.agree = empII.agree
        empF.megazine = empII.megazine
        empF.memo = empII.memo
        empF.registerDate = registerDate
        
        loginF.employeeNum = empII.employeeNum
        loginF.employeeId = empII.employeeId
        loginF.employeePw = empII.employeePw
    
        //INSERT 実行
        DB.shared.insertEmployee2(employee: [empF])
        DB.shared.insertLogin2(login: [loginF])
     

        dismiss(animated: true) {
            self.didSave?()
        }
    }

    @IBAction func exitBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: 外関数
    func returnPosition2(code:String) -> String {
        for postion in pos {
            if code == postion.name {
                return postion.code
            }
        }
        return ""
    }
    func returnTeam2(code:String) -> String {
        for team in teams {
            if code == team.name {
                return team.code
            }
        }
        return ""
    }
    func returnGender(num:Int) -> String {
        if num == 0 {
            return "男"
        } else if num == 1 {
            return "女"
        }
        return ""
    }
    func returnMegazie(num:Int) -> String {
        if num == 0 {
            return "不許可"
        } else if num == 1 {
            return "許可"
        }
        return ""
    }
    func returnAgree(num:Int) -> String {
        if num == 1 {
            return "同意"
        }
        return ""
    }
}
