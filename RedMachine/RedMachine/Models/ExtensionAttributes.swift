//
//  ExtensionAttributes.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/21.
//

import Foundation

struct ExtensionAttributes: Codable {
    var categoryLinks = [CategoryLink]()
    var stockItem: StockItem?
    var websiteIds = [Int]()
    
    private enum CodingKeys: String, CodingKey {
        case categoryLinks = "category_links"
        case stockItem = "stock_item"
        case websiteIds = "website_ids"
    }
}


