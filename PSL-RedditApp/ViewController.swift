//
//  ViewController.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/05/20.
//  Copyright © 2020 PSL All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var safeArea = UILayoutGuide()
    let stackView   = UIStackView()
    
    let CellIdentifier = Constants.CellIdentifier
    var feedManager = NewsManager()
    var totalResult: [Child] = []
    
    //To Fetch next sets of data
    var afterLink: String?
    var beforeLink: String?
    
    override func loadView() {
        super.loadView()
        showLoader()
        initialSetup()
        setupTableView()
        fetchFeedResult(url: Constants.baseUrl)
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        self.title = Constants.feedTitle
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(NewsCellTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(NewsCellTableViewCell.self))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchFeedResult(url: String) {
        feedManager.getFeedResult( urlString: url, completionHandler:{ receivedModel in
            guard let modelData = receivedModel else {
                //Error Handling
                let alert = UIAlertController(title: "Alert", message: Constants.genericErrorMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.totalResult.append(contentsOf: modelData.children)
            self.afterLink = modelData.after
            self.tableView.reloadData()
            self.hideLoader()
        })
    }
    
    private func showLoader() {
        self.tableView.isHidden = true
        feedManager.showHUD(thisView: self.view)
    }
    
    private func hideLoader() {
        self.tableView.isHidden = false
        feedManager.hideHUD()
    }
    
    private func loadMore() {
        // To prevent multiple API call
        if self.beforeLink == self.afterLink{
            return
        }
        if let after = self.afterLink {
            self.beforeLink = self.afterLink
            fetchFeedResult(url: Constants.fetchMoreUrl + after)
        }
    }
}

// MARK: - Extension
extension ViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NewsCellTableViewCell.self), for: indexPath) as? NewsCellTableViewCell{
            
            //Setting the data to the custom cell
            let cellData = totalResult[indexPath.row]
            cell.childData = cellData
            
            //Load more data if reach bottom of tableview
            if indexPath.row == totalResult.count - Constants.refreshOnScrollNo {
                self.loadMore()
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
