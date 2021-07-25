//
//  ViewController.swift
//  RedMachine
//
//  Created by Terry Xu on 2021/7/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import RealmSwift
import MJRefresh

final class ViewController: UIViewController {
    
    // MARK: - UI
    private var tableView: UITableView = UITableView()
    private var sortButton: UIButton = UIButton(type: .custom)
    private var reloadButton: UIButton = UIButton(type: .custom)
    private var loginButton: UIButton = UIButton(type: .custom)
    private var buttonView: UIView = UIView()
    
    // MARK: - Fields
    private let bag = DisposeBag()
    private let apiService = APIService()
    private var pageSize = NetworkConstant.PageSize
    
    // MARK: - Dependency
    lazy var viewModel: ViewModel = ViewModel(apiService: apiService)

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: NetworkConstant.TokenKey)
        setupUI()
        registerReusableViews()
        bindViewModel()
    }
    
    /// UI Layout
    private func setupUI() {
        title = "Product List"
        
        view.addSubViews([buttonView, tableView])
        
        buttonView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: buttonViewHeight).isActive = true
        
        buttonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupButtonViews()
        setupTableView()
        handleEvent()
    }
    
    private func setupButtonViews() {
        // Terry TODO: Create ButtonView.swift if got spare time
        buttonView.backgroundColor = .gray
        buttonView.accessibilityIdentifier = "buttonView"
        
        buttonView.addSubViews([reloadButton, loginButton, sortButton], intoContraints: false)
        
        reloadButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: buttonIndent).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        reloadButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
        
        loginButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true

        
        sortButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -buttonIndent).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        sortButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
        
        reloadButton.setTitle("Reload", for: .normal)
        loginButton.setTitle("Login", for: .normal)
        sortButton.setTitle("Sort by price", for: .normal)
        
        // Setting isExclusiveTouch property to true causes the receiver to block the delivery of touch events to other views in the same window.
        reloadButton.isExclusiveTouch = true
        loginButton.isExclusiveTouch = true
        sortButton.isExclusiveTouch = true
        
        reloadButton.accessibilityIdentifier = "reloadButton"
        loginButton.accessibilityIdentifier = "loginButton"
        sortButton.accessibilityIdentifier = "sortButton"
    }
    
    
    /// Setup TableView
    private func setupTableView() {
        tableView.accessibilityIdentifier = "tableView"
        tableView.backgroundColor = .white
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.estimatedRowHeight = 0
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(ViewController.loadMore))
        tableView.mj_footer = footer
    }
    
    private func registerReusableViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell
                            .description())
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.description())
    }
    
    private func bindViewModel() {
        viewModel.sections.asObservable()
            .do(afterNext: { [weak self] _ in
                self?.tableView.mj_footer?.endRefreshing()
            },
            afterError: { [weak self] _ in
                self?.tableView.mj_footer?.endRefreshing()
            })
            .bind(to: tableView.rx.items(dataSource: rxDataSource()))
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let this = self, let indexPath = value.element else { return }
                let item = this.item(at: indexPath)
                switch item {
                case .item(let item):
                    this.showProductDetail(sku: item.sku, indexPath: indexPath)
                    break
                }
            }
            .disposed(by: bag)

        viewModel.alertMessage.bind { [weak self] message in
            self?.showAlert(message: message)
        }
        .disposed(by: bag)
    }
    
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
                
                // Attention: Realm doesn't support cross-thread,
                // because there's thread protection in Realm.
                let realm = try! Realm()
                
                let storedItem = realm.object(ofType: ItemModel.self, forPrimaryKey: item.id)
                guard let itemModel = storedItem else { return productCell }
                cell?.updataBookmark(toMark: itemModel.isMarked)
            }
            return productCell
        }
        return dataSource
    }
    
    private func handleEvent() {
        reloadButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let this = self else { return }
                this.reloadData()
            }.disposed(by: bag)
        
        sortButton.rx.tap
            .bind(to: viewModel.sortEvent)
            .disposed(by: bag)
        
        loginButton.rx.tap.subscribe { [weak self] _ in
            self?.viewModel.login()
        }.disposed(by: bag)
    }
    
    private func reloadData() {
        pageSize = NetworkConstant.PageSize
        viewModel.fetchProductLists(pageSize: pageSize)
    }
    
    @objc private func loadMore() {
        pageSize += NetworkConstant.PageSize
        viewModel.fetchProductLists(pageSize: pageSize)
    }
    
    private func sortData() {
        
    }
    
    private func section(at index: Int) -> ItemSection {
        return viewModel.dataSource[index]
    }

    private func item(at indexPath: IndexPath) -> ItemType {
        return section(at: indexPath.section).items[indexPath.item]
    }
    
    private func showProductDetail(sku: String?, indexPath: IndexPath) {
        guard let sku = sku else {
            self.showAlert(message: noSku)
            return
        }
        let detailViewModel = DetailViewModel(apiService: apiService,
                                              sku: sku,
                                              indexPath: indexPath)
        handleEvent(detailViewModel)
        let detailViewController = DetailViewController()
        detailViewController.viewModel = detailViewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func handleEvent(_ detailViewModel: DetailViewModel) {
        detailViewModel.bookmarkObservable
            .subscribe { [weak self] toMark, indexPath in
                // No need to refresh all data source and refresh table view
                // Just update current cell.
                let cell = self?.tableView.cellForRow(at: indexPath) as? ProductTableViewCell
                cell?.updataBookmark(toMark: toMark)
        }.disposed(by: detailViewModel.bag)
    }
}

extension ViewController: UITableViewDelegate {
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
}


// MARK: - Constants
fileprivate extension ViewController {
    // UI Layout Constant
    var buttonViewHeight: CGFloat { 60 }
    var cellHeight: CGFloat { 70 }
    var buttonWidth: CGFloat { 120 }
    var buttonIndent: CGFloat { 30 }
    
    // String & Message
    var noSku: String { "Sku is empty, please try again." }
}

