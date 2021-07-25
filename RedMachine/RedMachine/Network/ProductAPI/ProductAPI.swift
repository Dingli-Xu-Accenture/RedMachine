//
//  ProductAPI.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation
import Moya

enum ProductAPI {
    case login(userName: String, password: String)
    case productList(pageSize: Int, direction: String, fieldName: String, fields: String)
    case product(sku: String)
}

extension ProductAPI: TargetType {
    var baseURL: URL {
        return NetworkConstant.BaseURL
    }
    
    var path: String {
        switch self {
        case .login:
            return "/integration/admin/token"
        case .product(let sku):
            return "/products/\(sku)"
        case .productList:
            return "/products"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .product:
            return .get
        case .productList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let userName, let password):
            let parameters = ["username": userName, "password": password]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        case .product:
            return .requestPlain
        case .productList(let pageSize, let direction, let fieldName, let fields):
            var parameters = [String: String]()
            parameters["searchCriteria[pageSize]"] = String(pageSize)
            parameters["searchCriteria[sortOrders][0][direction]"] = direction
            parameters["searchCriteria[sortOrders][0][field]"] = fieldName
            parameters["fields"] = fields
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json; charset=utf-8"]
    }
}

extension ProductAPI: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        .bearer
    }
}
