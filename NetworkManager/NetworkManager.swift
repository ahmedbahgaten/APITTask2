//
//  NetworkManager.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static func DataFetching (completionHandler: @escaping ([ServerResponse]?,Error?) -> Void){
        let FetchingDataObject = AuthenticationRouter.DataFetching
            AF.request(FetchingDataObject).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseData = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode([ServerResponse].self, from: responseData)
                        completionHandler(data, nil)
                    } catch {
                        print("Whoops, an error occured: \(error)")
                    }
                case.failure(let error):
                    completionHandler(nil,error)
                }
                
            }
        }
    }



