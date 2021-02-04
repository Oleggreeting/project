

import UIKit
protocol ListVictoryViewControllerDelegate: AnyObject {
    func setGamer(object:Gamer)
}

class ListVictoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let shared = Manager.shared
    weak var delegate: ListVictoryViewControllerDelegate?
    var index: Int? = nil
    var controller: UIViewController? = nil
//    var completionHandle: ((Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func createAlert(){
        let alert = UIAlertController(title: "Чё делаем?", message: "", preferredStyle: .actionSheet)
        let removAction = UIAlertAction(title: "delete", style: .destructive) { (_) in
            if self.index != nil{
                self.shared.listGamers.remove(at: self.index!)
                self.index = nil
                self.shared.save()
                print(self.shared.listGamers.count)
                self.tableView.reloadData()
            }
        }
        let playAction = UIAlertAction(title: "Play", style: .default) { (_) in
            self.delegate?.setGamer(object: self.shared.listGamers[self.index!])
            let navController = self.presentingViewController as? UINavigationController
            if let setingVC = navController?.viewControllers.first(where: {$0 is SettingViewController}) as? SettingViewController{
            navController?.popToViewController(setingVC, animated: false)
            }
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "Back", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(playAction)
        alert.addAction(removAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension ListVictoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shared.listGamers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {return UITableViewCell()}
        
//        completionHandle?(indexPath.item)
        cell.configCell(object: self.shared.listGamers[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        createAlert()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
