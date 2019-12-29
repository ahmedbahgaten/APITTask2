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
        
    }
    
    
}



