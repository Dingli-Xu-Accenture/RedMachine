//
//  MockAPIService.swift
//  RedMachineTests
//
//  Created by Terry Xu on 2021/7/26.
//

import Foundation
import RxSwift

public final class MockAPIService {
    // MARK: Init & dependencies
    private var _token: String
    private var _prodctLists: ProductList
    private var _product: Product
    
    init(token: String,
         prodctLists: ProductList,
         product: Product) {
        _token = token
        _prodctLists = prodctLists
        _product = product
    }
}

extension MockAPIService: APIServicing {
    func login(userName: String, password: String) -> Single<String?> {
        return .just(_token)
    }
    
    func fetchProductsList(pageSize: Int, direction: String, fieldName: String, fields: String) -> Single<ProductList?> {
        return .just(_prodctLists)
    }
    
    func fetchProduct(sku: String) -> Single<Product?> {
        return .just(_product)
    }
}
