# RedMachine
- [Running RedMachine](#running-redmachine)
- [MVVM Architecture](#mvvm-architecture)
- [Comments and Explainations](#comments-and-explainations)
- [Time Spend](#time-spend)
- [To Do List](#to-do-list)



## Running RedMachine
- Make sure you have access to the `RedMachine` repo.
- Make sure you switch `main` branch.
- Make sure you have installed gem and pod.

```sh
$ git clone https://github.com/Dingli-Xu-Accenture/RedMachine.git
$ cd RedMachine
$ pod install
$ open RedMachine.xcworkspace
```

Then run the 'RedMachine' target in Xcode.

## MVVM Architecture
### ViewController: `VC`
**Role:** (a) **bindings**, and (b) **Navigation** logic. 


### ViewModle: `VM`
**Role:**  (a) **Managing display state** and (b) **Responding to interactions**.  

### Views:  `V` 
**Role:** (a)**UI components** and (b) **Decorative**.

### Models or Services: `M`, `S`
**Role:** (a)**Data and business logic**

## Comments and Explainations

### Code comments

Use `RxSwift`, `RxCocoa` to bind `VM` and `V/VC`

Create subscription for events in `VM`,
In `ViewModel.swift`:
```swift
      // MARK: - events
    private var _sortEvent = PublishSubject<Void>()
    var sortEvent: AnyObserver<Void> { _sortEvent.asObserver() }
    
    private func handleEvent() {
        _sortEvent.asObservable()
            .subscribe { [weak self] _ in
                guard let this = self else { return }
                this.items.sort(by: <)
            }
            .disposed(by: bag)
    }
```

In `ViewController.swift`, tap button and emit event:
```swift
 sortButton.rx.tap
        .bind(to: viewModel.sortEvent)
        .disposed(by: bag)
```

Use `RxDataSource` to bind `viewModel`'s sections to `tableView`'s data source:
In `ViewController.swift`:
```swift
    private func bindViewModel() {
        viewModel.sections.asObservable()
            .do(afterNext: { [weak self] _ in
                self?.tableView.mj_footer?.endRefreshing()
            },
            afterError: { [weak self] _ in
                /// mj_footer for pull up loading
                self?.tableView.mj_footer?.endRefreshing()
            })
            .bind(to: tableView.rx.items(dataSource: rxDataSource()))
            .disposed(by: bag)
   }
```

`ItemSection` confirm to protocol `SectionModelType` for `RxTableViewSectionedReloadDataSource<Section: SectionModelType>` to return data source and populate cell.
In `ViewController.swift`:
```swift
    private func rxDataSource() -> RxTableViewSectionedReloadDataSource<ItemSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<ItemSection> { _, tableView, indexPath, item -> UITableViewCell in
            var cell: ProductTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.description(), for: indexPath) as? ProductTableViewCell
            guard let productCell = cell else {
                return UITableViewCell()
            }
            switch item {
            case .item(let item):
                productCell.populate(item: item)
                ...
            }
            return productCell
        }
        return dataSource
    }
```


Use `Moya` for network request.

Protocol `APIServicing` to declare request and `APIService` confirms to it.
If `Model` should be stored or be encoded/decoded for network request, confirm to `Codable`.

```swift
APIService: APIServicing {
    ...
    func fetchProductsList(pageSize: Int, direction: String, fieldName: String, fields: String) -> Single<ProductList?> {
        return
            apiProvider.rx.request(.productList(pageSize: pageSize,
                                                direction: direction,
                                                fieldName: fieldName,
                                                fields: fields))
            .parse(type: ProductList.self)
    }
    ...
 }
```

Use `Realm` to read/write local data for `ProductList`.

Attension:  
- `Realm` doesn't support cross-thread which means if you read data in sub-thread, you can't get back to main-thread to use it.
- Write data should be executed async.
- `Realm` can't store sturctures, so need to transform to class, like `ItemModel` in `ProductList.swift`

```swift
 bookmarkObservable
            // Write data should be executed async.
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
```

### Explanations and Solutions:
- A var of struct returns from back-end with incorrect type.

Solution: `value` will return string or another object, set value as optional then override `init(from decoder: Decoder)` use `decodeIfPresent` to decode.  

  ```swift
  struct CustomAttribute: Codable {
    var attributeCode: String?
    var value: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attributeCode = try? container.decodeIfPresent(String.self, forKey: .attributeCode)
        value = try? container.decodeIfPresent(String.self, forKey: .value)
    }
    
    private enum CodingKeys: String, CodingKey {
        case attributeCode = "attribute_code"
        case value
    }
  }
  ```
 
- Calculate cell's height instead of using constant value.
  ```swift
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate cell's height
        let cell = ProductTableViewCell(style: .default, reuseIdentifier: ProductTableViewCell.description())
        let item: ItemType = self.item(at: indexPath)
        switch item {
        case .item(let item):
            cell.populate(item: item)
        }
        let computedSize = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return computedSize.height
    }
  ```
- After bookmark a product, no need to refresh all data, update exact product by realm, then change the current cell.

In `ViewController.swift`:
```swift
  detailViewModel.bookmarkObservable
            .subscribe { [weak self] toMark, indexPath in
                // No need to refresh all data source and refresh table view
                // Just update current cell.
                let cell = self?.tableView.cellForRow(at: indexPath) as? ProductTableViewCell
                cell?.updataBookmark(toMark: toMark)
    // When detailViewModel de-allocated, the subscription should be diposed
   }.disposed(by: detailViewModel.bag)
```

## Time Spend:
- Create repo and workspace: 1h.
- Create Models: 2h (too much key-value without using library🤣).
- UI Layout: 3h
- Implement Network request and test APIs, display to view controller: 3h
- Local storage: 2h
- Bind VM and VC/V: 2h
- Extensions and code optimization: 1h
- Write README: 2h

Totally: 16h, time including test and resolve defect.

## To Do List
- Dependency Injection.
- Add ViewModel and UI Tests.
- Defer load for configuration or initialization of libriaries in `AppDelegate`.
- Import `SwiftyJSON` or `HandyJSON` for models.





