//
//  Fact.swift
//  iOSAssigment
//
//  Created by VEER TIWARI on 7/5/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import Foundation

struct FactList : Codable {
    let title: String?
    let facts: [Fact]?
    
    //Fact list coding keys
    enum CodingKeys: String, CodingKey {
        case title = "title" //Raw value for enum case must be a literal
        case facts = "rows"
    }
}
struct Fact : Codable {
    let title: String?
    let descriptions: String?
    let imageUrl: String?
    
    // Coding Keys for Facts
    enum CodingKeys: String, CodingKey {
        case title = "title" // Raw value for enum case must be a literal
        case descriptions = "description"
        case imageUrl = "imageHref"
    }
}
