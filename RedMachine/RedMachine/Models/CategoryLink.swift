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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try? container.decodeIfPresent(String.self, forKey: .categoryId)
        position = try container.decode(Int.self, forKey: .position)
    }
    
    private enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case position
    }
}
