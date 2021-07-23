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
    
    private var items = [Item]()
    var dataSource: [ItemSection] = [] {
        didSet {
            sections.onNext(dataSource)
        }
    }
    var sections = PublishSubject<[ItemSection]>()
    
    // MARK: - events
    private var _sortEvent = PublishSubject<Void>()
    var sortEvent: AnyObserver<Void> { _sortEvent.asObserver() }
    
    
    // MARK: - Initialize
    init(apiService: APIServicing) {
        self.apiService = apiService
        fetchProductLists()
        handleEvent()
    }
    
    // MARK: - Helpers
    
    private func handleEvent() {
        _sortEvent.asObservable()
            .subscribe { [weak self] _ in
                guard let this = self else { return }
                this.items.sort(by: <)
                this.setupSections(items: this.items)
            }
            .disposed(by: bag)
    }
    
    func fetchProductLists() {
        apiService
            .fetchProductsList(pageSize: 10,
                               direction: "ASC",
                               fieldName: "code",
                               fields: "items[sku,name,id,price]")
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let this = self else { return }
                    this.items = response?.items ?? []
                    this.setupSections(items: this.items)
                    print("Get products succeeds.")},
                onError: { error in
                    print("Get products catches error \(error.localizedDescription).")})
            .disposed(by: bag)
    }
    
    private func setupSections(items: [Item] = []) {
        let itemTypes: [ItemType] =
            items.map { .item(item: $0) }
        let itemsSection = ItemSection(items: itemTypes, type: .row)
        dataSource = [itemsSection]
    }
}
