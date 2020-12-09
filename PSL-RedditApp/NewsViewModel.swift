//
//  NewsViewModel.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/08/20.
//  Copyright © 2020 PSL All rights reserved.
//

import UIKit
import Foundation

class NewsViewModel {
    //create all the publinks
    var feedManager = NewsManager()
    var totalResult: [Child] = []
  
    //To Fetch next sets of data
    var afterLink: String?
    var beforeLink: String?
    
     func fetchFeedResult(url: String) {
        
        feedManager.getFeedResult( urlString: url, completionHandler:{ receivedModel in
            guard let modelData = receivedModel else {
                NotificationCenter.default.post(name: Notification.Name(Constants.NEWS_ARRIVED_FAILED), object: nil)
                   return
            }
            self.totalResult.append(contentsOf: modelData.children)
            self.afterLink = modelData.after
            NotificationCenter.default.post(name: Notification.Name(Constants.NEWS_ARRIVED_SUCCESS), object: nil)
            self.hideLoader()
        })
    }
    
     func loadMore() {
        // To prevent multiple API call
        if self.beforeLink == self.afterLink{
            return
        }
        if let after = self.afterLink {
            self.beforeLink = self.afterLink
            fetchFeedResult(url: Constants.fetchMoreUrl + after)
        }
    }
    
     func showLoader(myView : UIView) {
           feedManager.showHUD(thisView: myView)
       }
       
    private  func hideLoader() {
           feedManager.hideHUD()
       }
    
   
}
