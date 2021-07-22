//
//  ProductService.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation
import RxSwift
import Moya

final class APIService {
    private let apiProvider: MoyaProvider<ProductAPI>
    
    init(apiProvider: MoyaProvider<ProductAPI>) {
        self.apiProvider = apiProvider
    }
}

extension APIService: APIServicing {
    func fetchProductsList(pageSize: Int, direction: String, fieldName: String, fields: String) -> Single<ProductList?> {
        return
            apiProvider.rx.request(.productList(pageSize: pageSize,
                                                direction: direction,
                                                fieldName: fieldName,
                                                fields: fields))
            .parse(type: ProductList.self)
    }
    
    func fetchProduct(sku: String) -> Single<Product?> {
        return apiProvider.rx.request(.product(sku: sku)).parse(type: Product.self)
    }
}
