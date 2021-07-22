//
//  MediaGalleryEntries.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/21.
//

import Foundation

struct MediaGalleryEntry: Codable {
    var disabled: Bool = false
    var file: String?
    var id: Int = 0
    var label: String?
    var mediaType: String?
    var position: Int = 0
    var types = [String]()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        disabled = try container.decode(Bool.self, forKey: .disabled)
        file = try? container.decodeIfPresent(String.self, forKey: .file)
        id = try container.decode(Int.self, forKey: .id)
        label = try? container.decodeIfPresent(String.self, forKey: .label)
        mediaType = try? container.decodeIfPresent(String.self, forKey: .mediaType)
        position = try container.decode(Int.self, forKey: .position)
        types = try container.decode([String].self, forKey: .types)
    }
    
    private enum CodingKeys: String, CodingKey {
        case disabled
        case file
        case id
        case label
        case mediaType = "media_type"
        case position
        case types
    }
}
