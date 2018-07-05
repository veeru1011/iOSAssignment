//
//  APIManager.swift
//  iOSAssigment
//
//  Created by VEER BAHADUR TIWARI on 05/07/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import Foundation

struct APIURL
{
    static let baseURL = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
}

class APIManager: NSObject {
    
    private static var sharedInstance: APIManager = {
        let apiManager = APIManager(baseURL: APIURL.baseURL!)
        return apiManager
    }()
    
    let baseURL: URL
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    private override init() {
        self.baseURL = APIURL.baseURL!
    }
    
    class func shared() -> APIManager {
        return sharedInstance
    }
    
    func getFactList(completionHandler:@escaping(Bool,FactList?,String)->Void) -> Void  {
        
        let request = URLRequest(url: self.baseURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let responseStrInISOLatin = String(data: data, encoding:.isoLatin1)
                // converting the data in isoLatin1 encoding string becouse data is not in utf8 format
                guard let dataInUTF8Format = responseStrInISOLatin?.data(using: .utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                let decoder = JSONDecoder()
                let factlist = try decoder.decode(FactList.self, from: dataInUTF8Format)
                completionHandler(true,factlist,"")
                
            } catch let err {
                print("Err", err)
                completionHandler(false,nil,err.localizedDescription)
            }
        })
        task.resume()
        
    }
}