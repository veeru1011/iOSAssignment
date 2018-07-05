//
//  ViewController.swift
//  iOSAssigment
//
//  Created by VEER TIWARI on 7/5/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var factlist: FactList?
    var facts: [Fact]?
    let tableView = UITableView(frame:.zero, style: .grouped)
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
        indicator.color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        indicator.hidesWhenStopped = true
        return indicator
        
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTableView()
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - SetUp UI
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.01))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        }
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(self.refreshControl)
        tableView.register(FactViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setUpNavigation() {
        navigationItem.title = ""
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    // MARK: - Fetch Data from server
    
    func fetchData(){
        
        APIManager.shared().getFactList { (success, factlist, errorMessage) in
            switch success {
            case true :
                if let list = factlist {
                    self.factlist = list
                    if let facts = list.facts?.filter({ !($0.title == nil && $0.descriptions == nil && $0.imageUrl == nil) }) {
                        self.facts = facts
                    }
                    DispatchQueue.main.async {
                        self.navigationItem.title = self.factlist?.title
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        if self.refreshControl.isRefreshing {
                            self.refreshControl.endRefreshing()
                        }
                    }
                }
            case false:
                print(errorMessage)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let facts = facts {
            return facts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FactViewCell
        
        if let facts = facts {
            cell.fact =  facts[indexPath.row]
        }
        
        return cell
    }
    
}

