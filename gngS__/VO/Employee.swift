import Foundation


class Employee {
    var employeeNum: String = "" //PK 社員番号
    var employeeId: String = "" //UK ID
    var employeePw: String = "" //PassWord
    var employeeKanji: String = "" //漢字
    var employeeKana: String = "" //カナ
    var employeeEng: String = "" //ENG
    var tel: String = "" //電話番号
    var gender: Int = 3//性別
    var position: String = ""//役職
    var team: String = ""//所属
    var agree: Int = 0 //Defalut値:0　約款同意
    var megazine: Int = 0// megazine送信同意
    var memo: String = ""//memo
    var registerDate: String = "" //Defalut:SYSDATE 堂録日
    var changeDate: String = "" // 情報修正日
}
