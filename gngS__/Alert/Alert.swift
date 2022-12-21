import UIKit

class Alert: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func idEmpty() {
        let alert = UIAlertController(title: "", message: "アカウントを入力ください", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
