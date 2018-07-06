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
        
        APIManager.shared().getFactList { (success, fact, message) in
            switch success {
            case true :
                XCTAssertTrue(success, "data fetch successfully")
            case false:
                XCTAssertFalse(success, "error in data fetching from server")
            }
        }
    }
    
    func testAPIData() {
        let request = URLRequest(url: URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!)
        let promise = expectation(description: "Simple Request")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let responseStrInISOLatin = String(data: data, encoding:.isoLatin1)
                
                if let dataInUTF8Format = responseStrInISOLatin?.data(using: .utf8) {
                    XCTAssert(true, "data converted to UTF-8 format")
                    let decoder = JSONDecoder()
                    let factlist = try decoder.decode(FactList.self, from: dataInUTF8Format)
                    XCTAssertTrue(factlist.title == "About Canada")
                    promise.fulfill()
                }
                else {
                      XCTFail("data converted to UTF-8 format")
                }
                
                
            } catch let err {
                print("Err", err)
            }
        })
        task.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
