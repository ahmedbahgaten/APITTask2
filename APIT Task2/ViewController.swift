//
//  ViewController.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var ReceivedData = [ServerResponse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
        setTableViewDelegateAndDataSource()
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
    
}

