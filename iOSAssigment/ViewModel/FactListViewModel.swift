//
//  FactListViewModel.swift
//  iOSAssigment
//
//  Created by VEER BAHADUR TIWARI on 10/07/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import Foundation

class FactListViewModel: NSObject {
    
     let apiManager: APIManager!
     weak var dataSource : GenericDataSource<Fact>?
    
     var title: Dynamic<String>?
     var errorMessage: Dynamic<String>?
    
    init(apiMgr: APIManager = APIManager.shared(), dataSource : GenericDataSource<Fact>?) {
        self.dataSource = dataSource
        self.apiManager = apiMgr
        self.title = Dynamic("")
    }

    func getFactList(_ completion: (() -> Void )? = nil )  {
        NetworkManager.isUnreachable { _ in
            self.errorMessage = Dynamic(NoConnectivityMessage)
            completion?()
        }
        
        NetworkManager.isReachable { _ in
            self.apiManager.getFactList { (success, factlist, errorMessage) in
            switch success {
            case true :
                if let list = factlist {
                    
                    if let facts = list.facts?.filter({ !($0.title == nil && $0.descriptions == nil && $0.imageUrl == nil) }) {
                        self.dataSource?.data.value = facts
                    }
                    if let navTitle = list.title {
                        
                        self.title?.value = navTitle
                        DispatchQueue.main.async {
                            self.title?.value = navTitle
                        }
                    }
                }
                DispatchQueue.main.sync {
                   self.errorMessage?.value = ""
                }
            case false:
                DispatchQueue.main.sync {
                    self.errorMessage?.value = errorMessage
                }
                
            }
            completion?()
        }
        
        }
    }
}
