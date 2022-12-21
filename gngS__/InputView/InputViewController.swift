import UIKit

class InputViewController: UIViewController {
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //labelに入る
        idLabel.text = empII.EmployeeId
        kanjiLabel.text = empII.EmployeeKanji
        kanaLabel.text = empII.EmployeeKana
        engLabel.text = empII.EmployeeEng
        telLabel.text = empII.Tel
        positionLabel.text = empII.Position
        teamLabel.text = empII.Team
        genderLabel.text = returnGender(num: empII.Gender)
        megazineLabel.text = returnMegazie(num: empII.Megazine)
        agreeLabel.text = returnAgree(num: empII.Agree)
        memoLabel.text = empII.Memo
        
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
        
        empF.EmployeeNum = empII.EmployeeNum
        empF.EmployeeId = empII.EmployeeId
        empF.EmployeePw = empII.EmployeePw
        empF.EmployeeKanji = empII.EmployeeKanji
        empF.EmployeeKana = empII.EmployeeKana
        empF.EmployeeEng = empII.EmployeeEng
        empF.Tel = empII.Tel
        empF.Gender = empII.Gender
        empF.Position = returnPosition2(code: empII.Position)
        empF.Team = returnTeam2(code: empII.Team)
        empF.Agree = empII.Agree
        empF.Megazine = empII.Megazine
        empF.Memo = empII.Memo
        empF.RegisterDate = registerDate
        
        loginF.EmployeeNum = empII.EmployeeNum
        loginF.EmployeeId = empII.EmployeeId
        loginF.EmployeePw = empII.EmployeePw
    
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
            if code == postion.PositionName {
                return postion.PositionCode
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
