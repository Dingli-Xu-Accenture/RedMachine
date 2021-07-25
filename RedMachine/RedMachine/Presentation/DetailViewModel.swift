//
//  DetailViewModel.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/23.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Realm
import RealmSwift

class DetailViewModel {
    // MARK: - Fields
    private var apiService: APIServicing
    let sku: String
    let indexPath: IndexPath
    private var product: Product?
    
    let bag = DisposeBag()
    private var _productSubject = PublishSubject<Product>()
    var productObservable: Observable<Product> { _productSubject.asObservable() }
    
    private var _bookmarkEvent = PublishSubject<(Bool, IndexPath)>()
    var bookmarkObserver: AnyObserver<(Bool, IndexPath)> { _bookmarkEvent.asObserver() }
    var bookmarkObservable: Observable<(Bool, IndexPath)> { _bookmarkEvent.asObservable() }
    
    var _productMarkStatusSubject = PublishSubject<Bool>()
    var productMarkStatusObservable: Observable<Bool> { _productMarkStatusSubject.asObservable() }

    // MARK: - Initialize
    init(apiService: APIServicing,
         sku: String,
         indexPath: IndexPath) {
        self.apiService = apiService
        self.sku = sku
        self.indexPath = indexPath
        fetchProduct(sku)
        handleEvent()
    }
    
    private func fetchProduct(_ sku: String) {
        apiService
            .fetchProduct(sku: sku)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let this = self, let product = response else { return }
                    this.product = product
                    this._productSubject.onNext(product)
                    this.readLocalProduct(product: product)
                    print("Get product succeeds.")},
                onError: { error in
                    print("Get product catches error \(error.localizedDescription).")})
            .disposed(by: bag)
    }
    
    private func handleEvent() {
        bookmarkObservable
            // Handle data base should be async.
            .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "bookmark"))
            .subscribe { [weak self] (isMarked, _) in
                let realm = try! Realm()
                guard let product = self?.product else { return }
                let storedItem = realm.object(ofType: ItemModel.self, forPrimaryKey: product.id)
                if let itemModel = storedItem {
                    try! realm.write {
                        itemModel.isMarked = isMarked  
                    }
                } else  {
                    let itemModel = ItemModel()
                    itemModel.updateItemModel(product: product, toMark: isMarked)
                    try! realm.write {
                        realm.add(itemModel)
                    }
                }
            }
            .disposed(by: bag)
    }
    
    // Read product in reaml to get local storage data
    private func readLocalProduct(product: Product) {
        let realm = try! Realm()
        let storedItem = realm.object(ofType: ItemModel.self, forPrimaryKey: product.id)
        guard let item = storedItem else {
            return
        }
        _productMarkStatusSubject.onNext(item.isMarked)
    }
}
