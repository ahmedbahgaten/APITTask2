//
//  APITTableViewCell.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit

class APITTableViewCell: UITableViewCell {
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var BodyLabel: UILabel!
    
    func configure (userID:Int,ID:Int,Title:String,Body:String) {
        userIDLabel.text = String(userID)
        IDLabel.text = String(ID)
        TitleLabel.text = Title
        BodyLabel.text = Body
        
    }

}
