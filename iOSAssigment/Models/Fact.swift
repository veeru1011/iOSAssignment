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
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case facts = "rows"
    }
}
struct Fact : Codable {
    let title: String?
    let descriptions: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case descriptions = "description"
        case imageUrl = "imageHref"
    }
}
