import Foundation
import UIKit

class Toolbars {
    var textField:UITextField
    
    init(textField:(UITextField)) {
        
        self.textField = textField
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title:"完了", style: .done, target: self, action: #selector(done))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        self.textField.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        textField.endEditing(true)
    }
}


class ViewTollbars {
    
    var textView:UITextView
    
    init(textView:(UITextView)) {
        self.textView = textView
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title:"完了", style: .done, target: self, action: #selector(done))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        self.textView.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        textView.endEditing(true)
    }
}
