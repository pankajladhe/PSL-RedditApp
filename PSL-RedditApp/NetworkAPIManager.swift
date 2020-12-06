//
//  NetworkAPIManager.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/05/20.
//  Copyright © 2020 PSL All rights reserved.
//

import Foundation
import Alamofire

class NetworkAPIManager {
    static let shared : NetworkAPIManager = {
        let instance = NetworkAPIManager()
        return instance
    }()
    
    //Check for Network Availabilty
    func isConnected() -> Bool {
           if let networkReachability = NetworkReachabilityManager() {
               return networkReachability.isReachable
           } else {
               return false
           }
       }

    func alamofireRequest(urlString : String, completionHandler: @escaping (Bool, Welcome?) ->()) {
    
        if self.isConnected() {
            AF.request(urlString).responseDecodable(of: Welcome.self) { (response) in
                guard let newData = response.value else {
                    completionHandler(false, nil)
                    return
                }
              completionHandler(true, newData)
            }
        } else {
            print("No Network")
        }
    }
}
