import Foundation


class Employee {
    var EmployeeNum: String = "" //PK
    var EmployeeId: String = "" //UK
    var EmployeePw: String = ""
    var EmployeeKanji: String = ""
    var EmployeeKana: String = ""
    var EmployeeEng: String = ""
    var Tel: String = ""
    var Gender: Int = 3
    var Position: String = ""
    var Team: String = ""
    var Agree: Int = 0 //Defalut値:0
    var Megazine: Int = 0
    var Memo: String = ""
    var RegisterDate: String = "" //Defalut:SYSDATE
    var ChangeDate: String = ""
}
