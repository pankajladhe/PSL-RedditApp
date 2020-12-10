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
    var safeArea  = UILayoutGuide()
    let stackView = UIStackView()
    
    let CellIdentifier = Constants.CellIdentifier
    var feedManager = NewsManager()
    var newsViewModel: NewsViewModel?
    
    override func loadView() {
        super.loadView()
        setupNotificationSubscription()
        initialSetup()
        setupTableView()
        instantiateViewModels()
    }
    
    // MARK: - Private Methods
    func setupNotificationSubscription() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDataFetchSuccess), name: NSNotification.Name(rawValue: Constants.NEWS_ARRIVED_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDataFetchFailure), name: NSNotification.Name(rawValue: Constants.NEWS_ARRIVED_FAILED), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNoificationSubscriptions()
    }
    
    func removeNoificationSubscriptions() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.NEWS_ARRIVED_SUCCESS), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.NEWS_ARRIVED_FAILED), object: nil)
    }
    
    func instantiateViewModels() {
        self.newsViewModel = NewsViewModel();
        self.tableView.isHidden = true
        feedManager.showHUD(thisView: self.view)
        newsViewModel!.fetchFeedResult(url: Constants.baseUrl)
    }
    
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
    
    @objc func onDataFetchSuccess() {
        self.tableView.reloadData()
        self.tableView.isHidden = false
        feedManager.hideHUD()
    }
    
    @objc func onDataFetchFailure() {
        self.tableView.reloadData()
        self.tableView.isHidden = true
        AlertControllerUtil.showAlert(viewController: self, title: Constants.DATA_FETCH_ERROR_TITLE, message: Constants.DATA_FETCH_ERROR_MESSAGE)
    }
    
   
}

// MARK: - Extension
extension ViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.newsViewModel?.totalResult.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NewsCellTableViewCell.self), for: indexPath) as? NewsCellTableViewCell{
            
            //Setting the data to the custom cell
            let cellData = self.newsViewModel?.totalResult[indexPath.row]
            cell.childData = cellData
            
            //Load more data if reach bottom of tableview
            if indexPath.row == self.newsViewModel!.totalResult.count - Constants.refreshOnScrollNo {
                feedManager.showHUD(thisView: self.view)
                newsViewModel!.loadMore()
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
