//
//  ProductList.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation
import RealmSwift

struct ProductList: Codable {
    var items = [Item]()
}

struct Item: Codable {
    var sku: String? = nil
    var name: String? = nil
    var id: Int = 0
    var price: Int = 1000
    var isMarked: Bool = false
    
    init(sku: String?, name: String?, id: Int = 0, price: Int, isMarked: Bool = false) {
        self.sku = sku
        self.name = name
        self.id = id
        self.price = price
        self.isMarked = isMarked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sku = try? container.decodeIfPresent(String.self, forKey: .sku)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        price = try container.decode(Int.self, forKey: .price)
    }
    
    mutating func setBookMark(toMark: Bool) {
        self.isMarked = toMark
    }
}

extension Item: Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        return lhs.price < rhs.price
    }
}
 
class ItemModel: Object {
    @objc dynamic var sku: String? = nil
    @objc dynamic var id = 0
    @objc dynamic var name: String? = nil
    @objc dynamic var price = 0
    @objc dynamic var isMarked: Bool = false

    override static func primaryKey() -> String? {
        return "id"
    }
    // Config ignored properties.
    // As things stand, no need to store price.
    override static func ignoredProperties() -> [String] {
        return ["price"]
    }
    
    func updateItemModel(product: Product, toMark: Bool) {
        self.sku = product.sku
        self.id = product.id
        self.name = product.name
        self.price = product.price
        self.isMarked = !toMark
    }
}
