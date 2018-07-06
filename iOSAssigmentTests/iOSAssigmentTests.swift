//
//  iOSAssigmentTests.swift
//  iOSAssigmentTests
//
//  Created by VEER BAHADUR TIWARI on 06/07/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import XCTest
@testable import iOSAssigment

class iOSAssigmentTests: XCTestCase {
    
    
    func testAPICall() {
        
        APIManager.shared().getFactList { (success, fact, message) in
            switch success {
            case true :
                XCTAssertTrue(success, "data fetch successfully")
            case false:
                XCTAssertFalse(success, "error in data fetching from server")
            }
        }
    }
    
    func test() {
        
    }
    
}
