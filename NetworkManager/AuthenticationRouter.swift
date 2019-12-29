//
//  AuthenticationRouter.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import Foundation
import Alamofire

enum AuthenticationRouter :URLRequestConvertible {
    case DataFetching

    func asURLRequest() throws -> URLRequest {
        let url:URL = {
            switch self {
            case .DataFetching:
                return URL(string:"https://jsonplaceholder.typicode.com/posts")!
            }
        }()
        let HTTPMethod:HTTPMethod = {
            switch self {
            case .DataFetching:
                return .get
        }
        }()
        let urlRequest = try! URLRequest( url : url , method : HTTPMethod)
        return urlRequest
    }
    

    
    

}
