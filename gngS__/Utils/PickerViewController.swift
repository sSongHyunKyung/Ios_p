import UIKit

class PickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var pos = DB.shared.selectPositionAll()
    var teams = DB.shared.selectTeamAll()
    
    //PickerView フォルパティ
    var posPicker:UIPickerView = UIPickerView()
    var teamPicker:UIPickerView = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return pos.count
        case 2:
            return teams.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return pos[row].positionName
        case 2:
            return teams[row].teamName
        default:
            return "EEROR"
        }
    }
    

    func toolbars(view:UIView) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title:"決定", style: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(title:"キャンセル", style: .done, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
    }
    @objc func done(textField:UITextField) {
        textField.endEditing(true)
        textField.text = "\(pos[posPicker.selectedRow(inComponent: 0)].positionName)"
    }
    @objc func cancel(textField:UITextField){
        textField.endEditing(true)
    }
}
