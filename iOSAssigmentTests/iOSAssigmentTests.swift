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
    
    
    func testAPICallUsingAPIManger() {
        
        let promise = expectation(description: "Simple Request")
        APIManager.shared().getFactList { (success, factlist, message) in
            switch success {
            case true :
                XCTAssertTrue(success, "data fetch successfully")
                XCTAssertTrue(factlist?.title == "About Canada")// Test for title
                XCTAssertTrue(factlist?.facts?.count == 14)// Check total fact count should be 14
                XCTAssertEqual(message, EmptyString) // Check message is a Empty String
                promise.fulfill()
            case false:
                XCTAssertFalse(success, "error in data fetching from server")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
