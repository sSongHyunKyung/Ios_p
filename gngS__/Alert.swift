import UIKit

class Alert: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    func Idempty() {
        let alert = UIAlertController(title: "", message: "アカウントを入力ください", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        return
    }

}
