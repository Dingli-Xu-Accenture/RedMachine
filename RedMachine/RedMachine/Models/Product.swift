import Foundation

struct Product: Codable {
	var attributeSetId: Int = 0
	var createdAt: String?
	var customAttributes = [CustomAttribute]()
	var extensionAttributes: ExtensionAttributes?
	var id: Int = 0
	var mediaGalleryEntries = [MediaGalleryEntry]()
	var name: String?
	var options = [Option]()
	var price: Int = 0
	var productLinks = [ProductLink]()
	var sku: String?
	var status: Int = 0
	var tierPrices = [TierPrice]()
	var typeId: String?
	var updatedAt: String?
	var visibility: Int = 0
	var weight: Int = 0
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attributeSetId = try container.decode(Int.self, forKey: .attributeSetId)
        createdAt = try? container.decodeIfPresent(String.self, forKey: .createdAt)
        customAttributes = try container.decode([CustomAttribute].self, forKey: .customAttributes)
        extensionAttributes = try? container.decodeIfPresent(ExtensionAttributes.self, forKey: .extensionAttributes)
        id = try container.decode(Int.self, forKey: .id)
        mediaGalleryEntries = try container.decode([MediaGalleryEntry].self, forKey: .mediaGalleryEntries)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        options = try container.decode([Option].self, forKey: .options)
        price = try container.decode(Int.self, forKey: .price)
        productLinks = try container.decode([ProductLink].self, forKey: .productLinks)
        sku = try? container.decodeIfPresent(String.self, forKey: .sku)
        status = try container.decode(Int.self, forKey: .status)
        tierPrices = try container.decode([TierPrice].self, forKey: .tierPrices)
        typeId = try? container.decodeIfPresent(String.self, forKey: .typeId)
        updatedAt = try? container.decodeIfPresent(String.self, forKey: .updatedAt)
        visibility = try container.decode(Int.self, forKey: .visibility)
        weight = try container.decode(Int.self, forKey: .weight)
    }
    
    private enum CodingKeys: String, CodingKey {
        case attributeSetId = "attribute_set_id"
        case createdAt = "created_at"
        case customAttributes = "custom_attributes"
        case extensionAttributes = "extension_attributes"
        case id
        case mediaGalleryEntries = "media_gallery_entries"
        case name
        case options
        case price
        case productLinks = "product_links"
        case sku
        case status
        case tierPrices = "tier_prices"
        case typeId = "type_id"
        case updatedAt = "updated_at"
        case visibility
        case weight
    }
}


