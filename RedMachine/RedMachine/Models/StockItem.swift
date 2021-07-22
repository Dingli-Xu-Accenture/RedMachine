//
//  StockItem.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/21.
//

import Foundation

struct StockItem: Codable {
    var backorders: Int = 0
    var enableQtyIncrements: Bool = false
    var isDecimalDivided: Bool = false
    var isInStock: Bool = false
    var isQtyDecimal: Bool = false
    var itemId: Int = 0
    var lowStockDate: String?
    var manageStock: Bool = false
    var maxSaleQty: Int = 0
    var minQty: Int = 0
    var minSaleQty: Int = 0
    var notifyStockQty: Int = 0
    var productId: Int = 0
    var qty: Int = 0
    var qtyIncrements: Int = 0
    var showDefaultNotificationMessage: Bool = false
    var stockId: Int = 0
    var stockStatusChangedAuto: Int = 0
    var useConfigBackorders: Bool = false
    var useConfigEnableQtyInc: Bool = false
    var useConfigManageStock: Bool = false
    var useConfigMaxSaleQty: Bool = false
    var useConfigMinQty: Bool = false
    var useConfigMinSaleQty: Int = 0
    var useConfigNotifyStockQty: Bool = false
    var useConfigQtyIncrements: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backorders = try container.decode(Int.self, forKey: .backorders)
        enableQtyIncrements = try container.decode(Bool.self, forKey: .enableQtyIncrements)
        isDecimalDivided = try container.decode(Bool.self, forKey: .isDecimalDivided)
        isInStock = try container.decode(Bool.self, forKey: .isInStock)
        isQtyDecimal = try container.decode(Bool.self, forKey: .isQtyDecimal)
        itemId = try container.decode(Int.self, forKey: .itemId)
        lowStockDate = try? container.decodeIfPresent(String.self, forKey: .lowStockDate)
        manageStock = try container.decode(Bool.self, forKey: .manageStock)
        maxSaleQty = try container.decode(Int.self, forKey: .maxSaleQty)
        minQty = try container.decode(Int.self, forKey: .minQty)
        minSaleQty = try container.decode(Int.self, forKey: .minSaleQty)
        notifyStockQty = try container.decode(Int.self, forKey: .notifyStockQty)
        productId = try container.decode(Int.self, forKey: .productId)
        qty = try container.decode(Int.self, forKey: .qty)
        qtyIncrements = try container.decode(Int.self, forKey: .qtyIncrements)
        showDefaultNotificationMessage = try container.decode(Bool.self, forKey: .showDefaultNotificationMessage)
        stockId = try container.decode(Int.self, forKey: .stockId)
        stockStatusChangedAuto = try container.decode(Int.self, forKey: .stockStatusChangedAuto)
        useConfigBackorders = try container.decode(Bool.self, forKey: .useConfigBackorders)
        useConfigEnableQtyInc = try container.decode(Bool.self, forKey: .useConfigEnableQtyInc)
        useConfigManageStock = try container.decode(Bool.self, forKey: .useConfigManageStock)
        useConfigMaxSaleQty = try container.decode(Bool.self, forKey: .useConfigMaxSaleQty)
        useConfigMinQty = try container.decode(Bool.self, forKey: .useConfigMinQty)
        useConfigMinSaleQty = try container.decode(Int.self, forKey: .useConfigMinSaleQty)
        useConfigNotifyStockQty = try container.decode(Bool.self, forKey: .useConfigNotifyStockQty)
        useConfigQtyIncrements = try container.decode(Bool.self, forKey: .useConfigQtyIncrements)

    }
    
    private enum CodingKeys: String, CodingKey {
        case backorders
        case enableQtyIncrements = "enable_qty_increments"
        case isDecimalDivided = "is_decimal_divided"
        case isInStock = "is_in_stock"
        case isQtyDecimal = "isQtyDecimal"
        case itemId = "item_id"
        case lowStockDate = "low_stock_date"
        case manageStock = "manage_stock"
        case maxSaleQty = "max_sale_qty"
        case minQty = "min_qty"
        case minSaleQty = "min_sale_qty"
        case notifyStockQty = "notify_stock_qty"
        case productId = "product_id"
        case qty
        case qtyIncrements = "qty_increments"
        case showDefaultNotificationMessage = "show_default_notification_message"
        case stockId = "stock_id"
        case stockStatusChangedAuto = "stock_status_changed_auto"
        case useConfigBackorders = "use_config_backorders"
        case useConfigEnableQtyInc = "use_config_enable_qty_inc"
        case useConfigManageStock = "use_config_manage_stock"
        case useConfigMaxSaleQty = "use_config_max_sale_qty"
        case useConfigMinQty = "use_config_min_qty"
        case useConfigMinSaleQty = "use_config_min_sale_qty"
        case useConfigNotifyStockQty = "use_config_notify_stock_qty"
        case useConfigQtyIncrements = "use_config_qty_increments"
    }
}
