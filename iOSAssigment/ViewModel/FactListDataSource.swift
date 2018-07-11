//
//  FactListDataSource.swift
//  iOSAssigment
//
//  Created by VEER BAHADUR TIWARI on 11/07/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class FactListDataSource: GenericDataSource<Fact>,  UITableViewDataSource {

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! FactViewCell
        
        let fact = self.data.value[indexPath.row]
        cell.fact = fact
        
        return cell
    }

}
