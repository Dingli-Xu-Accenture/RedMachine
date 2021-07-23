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

final class ViewController: UIViewController {
    
    // MARK: - UI
    private var tableView: UITableView = UITableView()
    private var sortButton: UIButton = UIButton(type: .custom)
    private var reloadButton: UIButton = UIButton(type: .custom)
    private var buttonView: UIView = UIView()
    
    // MARK: - Fields
    private let bag = DisposeBag()
    private let apiService = APIService()
    
    // MARK: - Dependency
    lazy var viewModel: ViewModel = ViewModel(apiService: apiService)

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        buttonView.addSubViews([reloadButton, sortButton], intoContraints: false)
        
        reloadButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: buttonIndent).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        reloadButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
        
        sortButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -buttonIndent).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        sortButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
        
        reloadButton.setTitle("Reload", for: .normal)
        sortButton.setTitle("Sort by price", for: .normal)
        
        // Setting isExclusiveTouch property to true causes the receiver to block the delivery of touch events to other views in the same window.
        reloadButton.isExclusiveTouch = true
        sortButton.isExclusiveTouch = true
    }
    
    
    /// Setup TableView
    private func setupTableView() {        
        tableView.backgroundColor = .white
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func registerReusableViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UIConstant.CellIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: rxDataSource()))
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let this = self, let indexPath = value.element else { return }
                let item = this.item(at: indexPath)
                switch item {
                case .item(let item):
                    this.showProductDetail(sku: item.sku)
                    break
                }
            }
            .disposed(by: bag)

    }
    
    private func rxDataSource() -> RxTableViewSectionedReloadDataSource<ItemSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<ItemSection> { _, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.CellIdentifier, for: indexPath)
            switch item {
            case .item(let item):
                cell.textLabel?.text = String(item.price)
            }
            return cell
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
    }
    
    private func reloadData() {
        viewModel.fetchProductLists()
    }
    
    private func sortData() {
        
    }
    
    private func section(at index: Int) -> ItemSection {
        return viewModel.dataSource[index]
    }

    private func item(at indexPath: IndexPath) -> ItemType {
        return section(at: indexPath.section).items[indexPath.item]
    }
    
    private func showProductDetail(sku: String?) {
        guard let sku = sku else {
            self.showAlert(message: noSku)
            return
        }
        let detailViewModel = DetailViewModel(apiService: apiService, sku: sku)
        let detailViewController = DetailViewController()
        detailViewController.viewModel = detailViewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}


// MARK: - Constants
fileprivate extension ViewController {
    // UI Layout Constant
    var buttonViewHeight: CGFloat { 60 }
    var cellHeight: CGFloat { 80 }
    var buttonWidth: CGFloat { 120 }
    var buttonIndent: CGFloat { 30 }
    
    // String & Message
    var noSku: String { "Sku is empty, please try again." }
}

