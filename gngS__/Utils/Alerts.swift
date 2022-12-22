import Foundation
import UIKit

class Alerts {
    
    init(viewController:UIViewController, msg:String, buttonTitle:String,handler:((UIAlertAction) -> Swift.Void)?) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(defaultAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
//    func showAlert(viewController: UIViewController, msg:String, buttonTitle: String, handler:((UIAlertAction) -> Swift.Void)?) {
//        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
//        alertController.addAction(defaultAction)
//        viewController.present(alertController, animated: true, completion: nil)
//        return
//    }
}
