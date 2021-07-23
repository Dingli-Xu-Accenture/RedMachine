//
//  AppConstants.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation

// MARK: - Network Service Constant

struct NetworkConstant {
    static let BaseURL = URL(string: "https://stg.milwaukeetool.co.jp/rest/default/V1")!

    // Terry TODO: Token may be expired, need to refresh token if
    // unauthorized with current token.
    static let Token = "z80pmn6dv6ddkmhnxh9r1ahioffeffxl"
}

// MARK: - UI Constant
struct UIConstant {
    static let CellIdentifier = "UITableViewCell"
}
