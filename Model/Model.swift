//
//  Model.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import Foundation

struct ServerResponse:Codable {
    let userId:Int?
    let id:Int?
    let title:String?
    let body:String?
}
