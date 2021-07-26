//
//  ViewModelSpec.swift
//  RedMachineTests
//
//  Created by Terry Xu on 2021/7/26.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

@testable import RedMachine

class ViewModelSpec: QuickSpec {
    override func spec() {
        describe("ViewModelSpec") {
            var sut: ViewModel!
            var bag: DisposeBag!
            var mockAPIService: APIServicing!
            
            var testScheduler: TestScheduler!
            var alertMessageObserver: TestableObserver<String>!
            
            let mockToken =  "token"
            let mockSku = "sku"
            
            beforeEach {
                bag = DisposeBag()
                // mock 1 element product list
                let mockItems = [
                    Item(sku: mockSku, name: "abc", id: 10, price: 100, isMarked: false),
                    Item(sku: "sku-2", name: "cde", id: 20, price: 50, isMarked: false),
                ]
                let mockProductLists: ProductList = ProductList(items: mockItems)
                testScheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
                mockAPIService = MockAPIService(token: mockToken, prodctLists: mockProductLists, product: Product(sku: mockSku, id: 10, price: 100))
                sut = ViewModel(apiService: mockAPIService)
            }
            
            context("Login and get token") {
                beforeEach {
                    alertMessageObserver = testScheduler.createObserver(String.self)
                    sut.alertMessage.bind(to: alertMessageObserver).disposed(by: bag)
                    sut.login()
                }
                
                it("Token stored in UserDefault should be mock token") {
                    expect(UserDefaults.standard.value(forKey: NetworkConstant.TokenKey) as? String).to(equal(mockToken))
                }
                
                it("Alert controller pop-up show message `Login successfully`") {
                    expect(alertMessageObserver.events.count).to(equal(1))
                    expect(alertMessageObserver.events.first?.value.element).to(equal("Login successfully!"))

                }
            }
            
            context("Get data source after fetchProductLists") {
                beforeEach {
                    sut.fetchProductLists()
                }
                
                it("data source is 1 section with 2 rows") {
                    expect(sut.dataSource.count).to(equal(1))
                    expect(sut.dataSource.first?.items.count).to(equal(2))
                }
                
                it("The first product in product list is mock sku") {
                    let item: ItemType! = sut.dataSource.first?.items.first!
                    switch item {
                    case .item(let item):
                        expect(item.sku).to(equal(mockSku))
                    case .none:
                        break
                    }
                }
                
                context("Sort button clicked") {
                    beforeEach {
                        sut.sortEvent.onNext(())
                    }
                    
                    it("Data source should be sorted by price with <") {
                        let itemType1: ItemType! = sut.dataSource.first?.items.first!
                        let itemType2: ItemType! = sut.dataSource.first?.items.last!
                        if case .item(let item1) = itemType1, case .item(let item2) = itemType2 {
                            expect(item1.price < item2.price).to(equal(true))
                        }
                    }
                }
            }
        }
    }
}
