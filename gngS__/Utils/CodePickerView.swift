//import UIKit
//
//class CodePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
//
//    var items: [Code] = []
//    var textField: UITextField!
//
//    init(items: [Code], textfield: UITextField) {
//        self.items = items
//        self.textField = textfield
//        super.init(frame: .zero)
//
//        self.delegate = self
//        self.dataSource = self
//
//        textfield.inputView = self
//        showsSelectionIndicator = true
//
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
//        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let doneItem = UIBarButtonItem(title:"決定", style: .done, target: self, action: #selector(done))
//        let cancelItem = UIBarButtonItem(title:"キャンセル", style: .done, target: self, action: #selector(cancel))
//        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
//
//        self.textField.inputAccessoryView = toolbar
//    }
//
//    /// 使わない
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // 決定ボタンのアクション指定
//    @objc func done() {
//        textField.endEditing(true)
//        textField.text = getSelected().name
//    }
//    // キャンセルボタンのアクション指定
//    @objc func cancel(){
//        textField.endEditing(true)
//    }
//
//    func getSelected() -> Code {
//        let row = selectedRow(inComponent: 0)
//        return items[row]
//    }
//    
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        items.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        items[row].name
//    }
//
//    /*
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//    }*/
//
//}
