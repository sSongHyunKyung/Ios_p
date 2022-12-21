import UIKit


@IBDesignable class CustomUILabelL: UILabel {
    
    @IBInspectable var lefpadding: CGFloat = 12
    
    override func drawText(in rect: CGRect) {
         super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 0, left: lefpadding, bottom: 0, right: 0)))
     }

}
