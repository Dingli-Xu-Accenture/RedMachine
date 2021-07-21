//
//  CategoryLinks.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/21.
//

import Foundation

struct CategoryLink: Codable {
    var categoryId: String?
    var position: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case position
    }
}
