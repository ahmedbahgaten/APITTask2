import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    private var receivedData = [ServerResponse]()
    var receivedTitle = ""
    var receivedBody = ""
    var selectedIndex = 0
    var ID:Int = 0
    var userID:Int = 0
    
    lazy var Refresher:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .green
        refreshControl.addTarget(self, action: #selector(requestDataRefresher), for: .valueChanged)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
        setTableViewDelegateAndDataSource()
        self.hideKeyboardWhenTappedAround()
        tableView.refreshControl = Refresher
    }
    @IBAction func navigationBarButtonIsClicked(_ sender: Any) {
        navigateToSavingScreen()
    }
    @objc func requestDataRefresher(){
        getDataFromServer()
        let deadLine = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.Refresher.endRefreshing()
        }
    }
    func navigateToSavingScreen () {
        let SavingScreenController = storyboard?.instantiateViewController(identifier: "SavingScreen") as! SavingScreenViewController
        SavingScreenController.SavingDelegate = self
        present(SavingScreenController,animated: true,completion: nil)
    }
    func getDataFromServer () {
        NetworkManager.DataFetching { (serverResponse, Error) in
            guard let response = serverResponse else {return}
            self.receivedData = response
            self.tableView.reloadData()
        }
    }
    func setTableViewDelegateAndDataSource () {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        receivedData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: APITTableViewCell.cellIdentifier , for:indexPath ) as! APITTableViewCell
        cell.configure(item: receivedData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.receivedData.remove(at: indexPath.row)
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
        let savingScreenViewController = storyboard?.instantiateViewController(identifier: "SavingScreen") as! SavingScreenViewController
        savingScreenViewController.SavingDelegate = self
        savingScreenViewController.selectedItem = receivedData[index]
        savingScreenViewController.state = .update
        self.present(savingScreenViewController, animated: true, completion: nil)
    }   
}
extension HomeViewController:SavingDelegateProtocol  {
    func passingTitleAndBody(Title: String, Body: String, state:screenState) {
        switch state {
        case .add :
            receivedTitle = Title
            receivedBody = Body
            
             let userID = (receivedData.last?.userId ?? 0)  + 1
            let ID = (receivedData.last?.id ?? 0) + 1

            let object = ServerResponse(userId: userID , id: ID, title: receivedTitle, body: receivedBody)
            print(object.userId ?? 0,object.id ?? 0)
            receivedData.append(object)
            tableView.reloadData()
        case .update :
            receivedData[selectedIndex].title = Title
            receivedData[selectedIndex].body = Body
            tableView.reloadData()
        }
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

