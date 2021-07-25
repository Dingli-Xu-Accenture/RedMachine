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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryLinks = try container.decode([CategoryLink].self, forKey: .categoryLinks)
        stockItem = try? container.decodeIfPresent(StockItem.self, forKey: .stockItem)
        websiteIds = try container.decode([Int].self, forKey: .websiteIds)
    }
    
    private enum CodingKeys: String, CodingKey {
        case categoryLinks = "category_links"
        case stockItem = "stock_item"
        case websiteIds = "website_ids"
    }
}
