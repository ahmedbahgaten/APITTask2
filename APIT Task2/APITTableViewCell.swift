//
//  APITTableViewCell.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit

class APITTableViewCell: UITableViewCell {
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var BodyLabel: UILabel!
    
    
    
    func configure (Title:String,Body:String) {
        TitleLabel.text = Title
        BodyLabel.text = Body
        
    }

}
