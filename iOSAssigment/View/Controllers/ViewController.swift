//
//  ViewController.swift
//  iOSAssigment
//
//  Created by VEER TIWARI on 7/5/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import UIKit
import ANLoader

class ViewController: UIViewController {
    
    //ApiManger for initilising viewModel
    lazy var apiManger =  {
        return APIManager.shared()
    }
    //ViewModel
    var factListViewModel: FactListViewModel!
    //Initilize table view
    let tableView = UITableView(frame:.zero, style: .grouped)
    
    let dataSource = FactListDataSource()
    
    
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

        //Set Up Navigation bar
        setUpNavigation()
        
        //Set tableview object for displaying data
        setUpTableView()
        
        //initilise factListViewModel and setup for callback
        setUpFactListViewModel()
    
        // viewModel fetch data
        factListViewModel.getFactList()
    }
    
    // MARK: - SetUp ViewModel
    
    //  Set up factListViewModel and  Add All Listioner for viewModel data updated
    func setUpFactListViewModel() {
        
        //initilise FactListViewModel with DataSource
        factListViewModel = FactListViewModel(dataSource: dataSource)
        
        //Start Looding UI
        ANLoader.showLoading(Loading, disableUI: true)
        
        // Notifier for datasource fetch data
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if (self?.refreshControl.isRefreshing)! {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
        
        // Notifier for navigation title
        factListViewModel.title?.bindAndFire { [unowned self] in
            self.setNavigationTitle($0)
        }
        
        // Notifier for Error message
        factListViewModel.errorMessage?.bindAndFire { [unowned self] in
            if $0.count > 0 {
                self.showAlert($0)
            }
        }
        
        // Notifier for Loading message
        factListViewModel.isLoading?.bindAndFire { isLoading in
            if !isLoading {
                //Hide ANLoader after 100 milisecound
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    ANLoader.hide()
                }
            }
        }
    }
    
    // MARK: - UI Helper
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
        
        tableView.dataSource = self.dataSource
        tableView.estimatedRowHeight = 100
        tableView.accessibilityIdentifier = "table-factListTableView"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(self.refreshControl)
        tableView.register(FactViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }
    
    //  NavigationBar setup method
    func setUpNavigation() {
        navigationItem.title = EmptyString
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        
        //prefersLargeTitles for iOS11
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
    }

    //  Handle Pull to refresh method
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.factListViewModel.getFactList()
    }
    
    //  Update Navigation Title
    func setNavigationTitle(_ title: String) {
        DispatchQueue.main.async {
            self.navigationItem.title = title
        }
    }
    
    // MARK: - AlertMessage UI
    func showAlert(_ message: String, title: String = AlertTitle) {
        DispatchQueue.main.async {
            ANLoader.hide()
            let alertController = UIAlertController(title: title, message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: DismissButtonTitle, style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

