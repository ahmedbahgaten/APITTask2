//
//  ViewController.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit

class ViewController: UIViewController,AddingDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var ReceivedData = [ServerResponse]()
    var ReceivedTitle = ""
    var ReceivedBody = ""
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let AddingScreenViewController = storyBoard.instantiateViewController(identifier: "AddingScreen") as! AddingScreenViewController
        AddingScreenViewController.AddDelegate = self
        present(AddingScreenViewController,animated: true,completion: nil)
    }
    @objc func requestData(){
        getDataFromAPI()
        let deadLine = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.refreshControl.endRefreshing()
        }
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
    func passingTitleAndBody(Title: String, Body: String) {
        ReceivedTitle = Title
        ReceivedBody = Body
        let object = ServerResponse(userId: 1, id: 2, title: ReceivedTitle, body: ReceivedBody)
        ReceivedData.append(object)
        tableView.reloadData()
  
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
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

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

