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

class ViewController: UIViewController {
    
    // MARK: - UI
    var tableView: UITableView!
    
    // MARK: - Fields
    var dataArray = [Product]()
    private let bag = DisposeBag()
    
    // MARK: - Dependency
    var viewModel: ViewModel = ViewModel(apiService: APIService(apiProvider: MoyaProvider<ProductAPI>()))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerReusableViews()
        bindViewModel()
    }
    
    private func registerReusableViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: self.view.frame)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .white
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func bindViewModel() {
        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: rxDataSource()))
            .disposed(by: bag)
    }
    
    private func rxDataSource() -> RxTableViewSectionedReloadDataSource<ItemSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<ItemSection> { _, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            switch item {
            case .item(let item):
                cell.textLabel?.text = item.name
                cell.detailTextLabel?.text = String(item.price)
            }
            return cell
        }

           
        return dataSource
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

