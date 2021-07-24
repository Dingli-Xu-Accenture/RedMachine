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
    static let Token = "y3fq5d5mnqgi55bpvnlxfces8aduxi5w"
}
