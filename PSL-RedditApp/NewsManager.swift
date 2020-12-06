//
//  NewsManager.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/05/20.
//  Copyright © 2020 PSL All rights reserved.
//

import Foundation
import JGProgressHUD

class NewsManager {
    
    let hud = JGProgressHUD(style: .dark)
    
    func getFeedResult(urlString: String, completionHandler: @escaping (WelcomeData?) ->()) {
        let feedUrlString = urlString
        NetworkAPIManager.shared.alamofireRequest(urlString: feedUrlString, completionHandler:{ isfetchSuccess, receivedModel in
            if isfetchSuccess {
                print("Success")
                guard let welcomeModel = receivedModel else {
                    completionHandler(nil)
                    return
                }
                completionHandler(welcomeModel.data)
            } else {
                print("fail")
                self.hideHUD()
                completionHandler(nil)
            }
        })
    }
    
    func showSuccessHUD(thisView :UIView) {
        self.hideHUD()
        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        hud.textLabel.text = Constants.success 
        hud.show(in: thisView)
        hud.dismiss(afterDelay: 1.0)
    }
    
    func showHUD(thisView :UIView) {
        hud.textLabel.text = Constants.loading
        hud.show(in: thisView)
    }
    
    func hideHUD() {
        hud.dismiss()
    }
}
