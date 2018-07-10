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
     var factList : FactList?
     var facts : [Fact]?
     var errorMessage : String?
    
    
    init(apiMgr: APIManager) {
        self.apiManager = apiMgr
        super.init()
    }
    
    func getFactList(completion: @escaping() -> Void )  {
        NetworkManager.isUnreachable { _ in
            self.errorMessage = NoConnectivityMessage
            completion()
        }
        
        NetworkManager.isReachable { _ in
            
            self.apiManager.getFactList { (success, factlist, errorMessage) in
                
            switch success {
            case true :
                if let list = factlist {
                    self.factList = list
                    if let facts = list.facts?.filter({ !($0.title == nil && $0.descriptions == nil && $0.imageUrl == nil) }) {
                        self.facts = facts
                    }
                }
                self.errorMessage = nil
            case false:
                self.errorMessage = errorMessage
            }
            completion()
        }
        
        }
    }
    
    func navigationTitle() -> String {
        return self.factList?.title ?? ""
    }
    
    func numberOfFactsToDisplay() -> Int {
        if let facts = facts {
            return facts.count
        }
        return 0
    }
    
    func factAtIndex(index: Int) -> Fact? {
        if let facts = facts {
            return facts[index]
        }
        return nil
    }
    
    func getErrorMessage() -> String? {
        return self.errorMessage
    }
}
