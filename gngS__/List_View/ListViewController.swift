import UIKit

class ListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate {
    
    //DB情報
    var empDB = DB.shared.selectEmployee()
    var posDB = DB.shared.selectPosition()
    var teamDB = DB.shared.selectTeam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListTableView.dataSource = self
        ListTableView.delegate = self
    }
    
    @IBOutlet weak var ListTableView: UITableView!
    
    //viewNumberRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empDB.count
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ListTableViewCell連結
        guard let cell = ListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ListTableViewCell else {
            fatalError("Dequeue failed: AnimalTableViewCell.")
        }
        //row値
        cell.numLabel.text = empDB[indexPath.row].employeeNum
        cell.nameLabel.text = empDB[indexPath.row].employeeKanji
        cell.positionLabel.text = posDB[indexPath.row].name
        cell.teamLabel.text = teamDB[indexPath.row].name
        
        return cell
    }
    
    //Segueか実行する前に実行
    //Segueでデータ移動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateSegue" {
            if let indexPath = ListTableView.indexPathForSelectedRow {
                guard let destination = segue.destination as? UpdateViewController else {
                    fatalError("Failed")
                }
                destination.emps = empDB[indexPath.row]
            }
        }
    }
    
    //View Controllerが再度表示される時セルの選択が解除
    //UpdateViewControllerが戻りどころ
    override func viewWillAppear(_ animated: Bool) {
        
        //cell click animation
        if let indexPath = ListTableView.indexPathForSelectedRow{
            ListTableView.deselectRow(at: indexPath, animated: true)
        }
        //reloadData
        empDB = DB.shared.selectEmployee()
        posDB = DB.shared.selectPosition()
        teamDB = DB.shared.selectTeam()
        ListTableView.reloadData().self
    }
}
