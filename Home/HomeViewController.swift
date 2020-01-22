import UIKit
protocol homeViewProtocol:class {
    func reloadData()
    func presentViewController (viewController:UIViewController)
}
class HomeViewController: UIViewController,homeViewProtocol{
    //MARK:-Variables
    var selectedIndex = 0
    var presenter:homePresenter!
    var router:homeRouter!
    lazy var Refresher:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .green
        refreshControl.addTarget(self, action: #selector(requestDataRefresher), for: .valueChanged)
        return refreshControl
    }()
    //MARK:-Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:-Actions
    @IBAction func addButtonIsTapped(_ sender: Any) {
        self.presenter.navigateToSavingScreen(view: self)
    }
    //MARK:-DidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeConfigurator.Configure(homeViewController: self)
        tableViewSetup()
        self.hideKeyboardWhenTappedAround()
        tableView.refreshControl = Refresher
        self.presenter.fetchData()
    }
    //MARK:-Functions
    @objc func requestDataRefresher(){
        self.presenter.fetchData()
        let deadLine = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadLine) { 
            self.Refresher.endRefreshing()
        }
    }
    func tableViewSetup () {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func reloadData() {
        self.tableView.reloadData()
    }
    func tableViewReturn() -> UITableView {
        return tableView
    }
    func presentViewController(viewController: UIViewController) {
           present(viewController, animated: true, completion: nil)
       }
}
//MARK:-Setting Up the tableview
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.getDataCounter()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: APITTableViewCell.cellIdentifier , for:indexPath ) as! APITTableViewCell
        cell.configure(item: self.presenter.getItem(atIndex: indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.presenter.removeItemOfData(atIndex: indexPath.row)
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
        savingScreenViewController.selectedItem = self.presenter.getItem(atIndex: index)
        savingScreenViewController.state = .update
        self.present(savingScreenViewController, animated: true, completion: nil)
    }
}
//MARK:- Setting up the the implementation of delegate
extension HomeViewController:SavingDelegateProtocol  {
    func passingTitleAndBody(Title: String, Body: String, state:screenState) {
        switch state {
        case .add :
            self.presenter.addNewItem(title: Title, body: Body)
            tableView.reloadData()
        case .update :
            self.presenter.updateData(atIndex: selectedIndex,Title:Title,Body:Body)
            tableView.reloadData()
        }
    }
}
//MARK:- Adding a hidden keyboard functionality when tapped around
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

