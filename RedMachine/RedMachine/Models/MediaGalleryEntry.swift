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
