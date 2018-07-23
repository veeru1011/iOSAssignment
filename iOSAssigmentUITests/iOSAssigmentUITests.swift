//
//  iOSAssigmentUITests.swift
//  iOSAssigmentUITests
//
//  Created by VEER TIWARI on 7/23/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import XCTest

class iOSAssigmentUITests: XCTestCase {
    
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceApp() {
        
        self.measure {
            XCUIApplication().launch()
        }
    }
    
    func testTableInteraction() {
        
        app.launch()
        let tableView = app.tables["table-factListTableView"]
        XCTAssertTrue(tableView.exists, "The fact tableview exists")
        
        // Get an array of cells
        let tableCells = tableView.cells
        
        if tableCells.count > 0 {
          
            let promise = expectation(description: "Wait for table view Scrolling")
            tableView.swipeUp()
            tableView.swipeUp()
            tableView.swipeUp()
            promise.fulfill()
            waitForExpectations(timeout: 10, handler: nil)
            XCTAssertTrue(true, "Finished table view Scrolling")
            
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
        
    }
    
}
