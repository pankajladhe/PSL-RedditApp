//
//  Constants.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/05/20.
//  Copyright © 2020 PSL All rights reserved.
//

import Foundation

struct Constants {
    static let NEWS_ARRIVED_SUCCESS = "newsArrivedSuccess"
    static let NEWS_ARRIVED_FAILED = "newaArrivedFailed"
    static let baseUrl = "http://www.reddit.com/.json"
    static let fetchMoreUrl = "http://www.reddit.com/.json?after="
    static let feedTitle = "Reddit News Feed"
    static let CellIdentifier = "cell"
    static let genericErrorMessage = "Something went Wrong!"
    static let loading = "Loading.."
    static let success = "Success"
    static let refreshOnScrollNo = 5
    
    static let IMAGE_DOWNLOAD_SUCCESS = "imageDownloadSuccess"
    static let IMAGE_DOWNLOAD_FAILED = "imageDownloadFailed"
    static let DEFAULT_IMAGE_LINK = "self"
    static let PLACEHOLDER_IMAGE = "placeholder"
    static let DATA_FETCH_ERROR_MESSAGE = "Sorry, we cound not fetch your data."
    static let DATA_FETCH_ERROR_TITLE = "Error"
}
