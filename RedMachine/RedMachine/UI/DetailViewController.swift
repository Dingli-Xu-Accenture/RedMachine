//
//  DetailViewController.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/23.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    // MARK: - UI
    private var nameLabel: UILabel = UILabel()
    private var priceLabel: UILabel = UILabel()
    private var skuLabel: UILabel = UILabel()
    private var bookmarkButton: UIButton = UIButton()
    
    // MARK: - Fields
    var viewModel: DetailViewModel!
    var bag = DisposeBag()
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        bindViewModel()
        setupBookmark()
    }
    
    private func setupUI() {
        title = viewModel.sku
        view.addSubViews([nameLabel, priceLabel, skuLabel, bookmarkButton])
        
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalMargin).isActive = true
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalMargin).isActive = true
        skuLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: verticalMargin).isActive = true
        bookmarkButton.topAnchor.constraint(equalTo: skuLabel.bottomAnchor, constant: verticalMargin).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizonMargin).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        skuLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        priceLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        skuLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        bookmarkButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        bookmarkButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        bookmarkButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    private func setupBookmark() {
        /// If button shows Bookmark, user click button and will bookmark this product.
        /// If button shows Unookmark, user click button and will unbookmark this product.
        
        bookmarkButton.setTitle("Bookmark", for: .normal)
        bookmarkButton.setTitle("Unookmark", for: .selected)
        bookmarkButton.backgroundColor = .gray
    }
    
    private func bindViewModel() {
        viewModel.productObservable.map { $0.name }.bind(to: nameLabel.rx.text).disposed(by: bag)
        viewModel.productObservable.map { $0.sku }.bind(to: skuLabel.rx.text).disposed(by: bag)
        viewModel.productObservable.map { String($0.price) }.bind(to: priceLabel.rx.text).disposed(by: bag)
        
        bookmarkButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let this = self else { return }
                this.bookmarkButton.isSelected = !this.bookmarkButton.isSelected
                this.viewModel.bookmarkObserver.onNext((this.bookmarkButton.isSelected, this.viewModel.indexPath))
            }.disposed(by: bag)
    }
}

fileprivate extension DetailViewController {
    var verticalMargin: CGFloat { 20 }
    var horizonMargin: CGFloat { 20 }
    var buttonWidth: CGFloat { 100 }
    var buttonHeight: CGFloat { 40 }
}
