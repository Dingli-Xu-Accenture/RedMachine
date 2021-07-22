//
//  ViewModel.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation
import Moya
import RxSwift


class ViewModel {
    // MARK: - Fields
    private var apiService: APIServicing
    private let bag = DisposeBag()
    
    
    // MARK: - Initialize
    init(apiService: APIServicing) {
        self.apiService = apiService
        fetchProductLists()
    }
    
    // MARK: - Private Helpers
    func fetchProductLists() {
        apiService
            .fetchProductsList(pageSize: 10,
                               direction: "ASC",
                               fieldName: "code",
                               fields: "items[sku,name]")
            .subscribe(
                onSuccess: { response in
                    let items = response?.items
                    print("Get products succeeds. \(String(describing: items))")},
                onError: { error in
                    print("Get products catches error \(error.localizedDescription).")})
            .disposed(by: bag)
    }
    
    func fetchProduct() {
        apiService
            .fetchProduct(sku: "M18 DFC JP")
            .subscribe(
                onSuccess: { response in
                    print("Get products succeeds. \(String(describing: response))")},
                onError: { error in
                    print("Get products catches error \(error.localizedDescription).")})
            .disposed(by: bag)
    }
    
}
