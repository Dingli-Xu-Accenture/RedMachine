//
//  ItemSection.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import CoreFoundation
import Differentiator
import RxSwift


struct ItemSection {
    var items: [ItemType]
    var type: ItemSectionType
}

enum ItemSectionType {
    case row
}

enum ItemType {
    case item(item: Item)
}

extension ItemSection: SectionModelType {
    public init(original: ItemSection, items: [ItemType]) {
        self.items = items
        self.type = original.type
    }
}
