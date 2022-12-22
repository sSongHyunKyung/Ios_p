import Foundation
import UIKit

class Regex{
    //MARK: 正規式
    
    //メール
    func isValidEmail(id: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: id)
    }
    //パスワード
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,24}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
    //カナ
    func Katakana(_ str: String) -> Bool {
        let regex = "^[ァ-ヾ]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    //漢字
    func Kanji(_ str: String) -> Bool {
        let regex = "^[\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}ぁ-ゔァ-ヴー]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    //Eng
    func Eng(_ str: String) -> Bool {
        let regex = "^[a-zA-Z]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
}
