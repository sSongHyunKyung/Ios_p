import UIKit

class KeyboardController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}








// キーボーと　隠れる
extension UIViewController {
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
