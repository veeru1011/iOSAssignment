//
//  APIManager.swift
//  iOSAssigment
//
//  Created by VEER BAHADUR TIWARI on 05/07/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import Foundation

struct APIURL {
    static let baseURL = URL(string: ApiBaseUrl)
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
    
     // Fetching data from server
    func getFactList(completionHandler:@escaping(Bool,FactList?,String)->Void) -> Void  {
        
        let request = URLRequest(url: self.baseURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let responseStrInISOLatin = String(data: data, encoding:.isoLatin1)
                // converting the data in isoLatin1 encoding string becouse data is not in utf8 format
                guard let dataInUTF8Format = responseStrInISOLatin?.data(using: .utf8) else {
                    print(UTF8ErrorMessage)
                    return
                }
                let decoder = JSONDecoder()
                let factlist = try decoder.decode(FactList.self, from: dataInUTF8Format)
                completionHandler(true,factlist,EmptyString)
                
            } catch let err {
                print(err)
                completionHandler(false,nil,err.localizedDescription)
            }
        })
        task.resume()
    }
}
