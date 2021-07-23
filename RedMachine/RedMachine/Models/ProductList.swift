//
//  ProductList.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation

struct ProductList: Codable {
    var items = [Item]()
}

struct Item: Codable {
    var sku: String?
    var name: String?
    var id: Int
    var price: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sku = try? container.decodeIfPresent(String.self, forKey: .sku)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        price = try container.decode(Int.self, forKey: .price)
    }
}

extension Item: Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        return lhs.price < rhs.price
    }
}
