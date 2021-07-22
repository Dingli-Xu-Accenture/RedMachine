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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sku = try? container.decodeIfPresent(String.self, forKey: .sku)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
    }
}
