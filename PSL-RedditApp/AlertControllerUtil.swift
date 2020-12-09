//
//  ViewController.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/08/20.
//  Copyright © 2020 PSL All rights reserved.
//

import Foundation
import UIKit

class AlertControllerUtil {
    static func showAlert(viewController: UIViewController?, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}
