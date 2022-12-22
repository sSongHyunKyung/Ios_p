import Foundation
import UIKit



// キーボーと　隠れる
class keyboard:UIViewController {
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
