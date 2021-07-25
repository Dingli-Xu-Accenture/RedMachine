//
//  CustomAttributes.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/21.
//

import Foundation

struct CustomAttribute: Codable {
    var attributeCode: String?
    var value: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attributeCode = try? container.decodeIfPresent(String.self, forKey: .attributeCode)
        value = try? container.decodeIfPresent(String.self, forKey: .value)
    }
    
    private enum CodingKeys: String, CodingKey {
        case attributeCode = "attribute_code"
        case value
    }
}
