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


