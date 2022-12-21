import UIKit


@IBDesignable class CustomUILabelR: UILabel {
    
    @IBInspectable var rightpadding: CGFloat = 12
    
    override func drawText(in rect: CGRect) {
         super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: rightpadding)))
     }
    
}
