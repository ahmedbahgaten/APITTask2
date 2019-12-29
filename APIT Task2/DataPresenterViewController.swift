import UIKit

class ViewController: UIViewController,SavingDelegateProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    private var ReceivedData = [ServerResponse]()
    var ReceivedTitle = ""
    var ReceivedBody = ""
    var selectedIndex = 0
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .green
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
        setTableViewDelegateAndDataSource()
        self.hideKeyboardWhenTappedAround()
        tableView.refreshControl = refreshControl
        
        
    }
    @IBAction func NavigationBarButtonIsClicked(_ sender: Any) {
        navigateToSavingScreen()
    }
    @objc func requestData(){
        getDataFromAPI()
        let deadLine = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.refreshControl.endRefreshing()
        }
    }
    func navigateToSavingScreen () {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let SavingScreenController = storyBoard.instantiateViewController(identifier: "AddingScreen") as! SavingScreenViewController
        SavingScreenController.SavingDelegate = self
        present(SavingScreenController,animated: true,completion: nil)
    }
    func getDataFromAPI () {
        NetworkManager.DataFetching { (serverResponse, Error) in
            guard let response = serverResponse else {return}
            self.ReceivedData = response
            self.tableView.reloadData()
        }
    }
    func setTableViewDelegateAndDataSource () {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func passingTitleAndBody(Title: String, Body: String, state:screenState) {
        switch state {
        case .add :
            ReceivedTitle = Title
            ReceivedBody = Body
            let object = ServerResponse(userId: 1, id: 2, title: ReceivedTitle, body: ReceivedBody)
            ReceivedData.append(object)
            tableView.reloadData()
        case .update :
            ReceivedData[selectedIndex].title = Title
            ReceivedData[selectedIndex].body = Body
            tableView.reloadData()
        }
        
        
    }
    
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ReceivedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "myCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier , for:indexPath ) as! APITTableViewCell
        
        let title = ReceivedData[indexPath.row].title
        let body = ReceivedData[indexPath.row].body
        cell.configure(Title: title ?? "", Body: body ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.ReceivedData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        deleteAction.backgroundColor = .red
        return swipeConfiguration
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        openUpdateScreeen(index: indexPath.row)
    }
    private func openUpdateScreeen(index: Int) {
        // open screeen
        let controller = storyboard?.instantiateViewController(identifier: "AddingScreen") as! SavingScreenViewController
        controller.SavingDelegate = self
        controller.selectedItem = ReceivedData[index]
        controller.state = .update
        self.present(controller, animated: true, completion: nil)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

