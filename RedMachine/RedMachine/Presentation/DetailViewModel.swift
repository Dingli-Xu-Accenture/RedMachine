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

class DetailViewModel {
    // MARK: - Fields
    private var apiService: APIServicing
    let sku: String
    let indexPath: IndexPath
    
    let bag = DisposeBag()
    private var _productSubject = PublishSubject<Product>()
    var productObservable: Observable<Product> { _productSubject.asObservable() }
    
    private var _bookmarkEvent = PublishSubject<(Bool, IndexPath)>()
    var bookmarkObserver: AnyObserver<(Bool, IndexPath)> { _bookmarkEvent.asObserver() }
    var bookmarkObservable: Observable<(Bool, IndexPath)> { _bookmarkEvent.asObservable() }
    var setProductMarkStatusObservable: Observable<(Bool, IndexPath)> = Observable.empty()

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
                    this._productSubject.onNext(product)
                    print("Get product succeeds.")},
                onError: { error in
                    print("Get product catches error \(error.localizedDescription).")})
            .disposed(by: bag)
    }
    
    private func handleEvent() {
        bookmarkObservable
            .subscribe { isMarked in
                
            }
            .disposed(by: bag)
    }
    
}
