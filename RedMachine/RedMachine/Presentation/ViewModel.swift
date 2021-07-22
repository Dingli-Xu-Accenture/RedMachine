//
//  ViewModel.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation
import Moya
import RxSwift
import RxRelay


class ViewModel {
    // MARK: - Fields
    private var apiService: APIServicing
    private let bag = DisposeBag()
    private var dataSource: [ItemSection] = [] {
        didSet {
            sections.onNext(dataSource)
        }
    }
    
    var sections = PublishSubject<[ItemSection]>()
    
    // MARK: - Initialize
    init(apiService: APIServicing) {
        self.apiService = apiService
        fetchProductLists()
    }
    
    // MARK: - Helpers
    func fetchProductLists() {
        apiService
            .fetchProductsList(pageSize: 10,
                               direction: "ASC",
                               fieldName: "code",
                               fields: "items[sku,name,id,price]")
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let this = self else { return }
                    let items = response?.items ?? []
                    this.setupSections(items: items)
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
    
    private func setupSections(items: [Item] = []) {
        let sortedItems: [ItemType] =
            items.sorted { $0.price < $1.price }
            .map { .item(item: $0) }
        let itemsSection = ItemSection(items: sortedItems, type: .row)
        dataSource = [itemsSection]
    }
}
