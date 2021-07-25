//
//  ProductTableViewCell.swift
//  RedMachine
//
//  Created by Terry Xu on 2021/7/24.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    // MARK: - UI Inputs
    var nameLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var skuLabel: UILabel = UILabel()
    var bookmark: UILabel = UILabel()

    // MARK: - Initialize
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
        clear()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        clear()
    }
    
    
    private func clear() {
        bookmark.text = "⭐️"
        bookmark.isHidden = true
        nameLabel.text = prefixName
        priceLabel.text = prefixPrice
        skuLabel.text = prefixSku
    }
    
    // MARK: - Layout
    private func setupUI() {
        self.contentView.addSubViews([nameLabel, skuLabel, priceLabel, bookmark])
        nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: horizonMargin).isActive = true
        skuLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: horizonMargin).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -horizonMargin).isActive = true
        bookmark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -horizonMargin).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: bookmark.centerYAnchor).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: skuLabel.centerYAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: verticalMargin).isActive = true
        skuLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalMargin).isActive = true
        skuLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -verticalMargin).isActive = true
        
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: labelMaxWidth).isActive = true
        skuLabel.widthAnchor.constraint(lessThanOrEqualToConstant: labelMaxWidth).isActive = true
        priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: labelMaxWidth).isActive = true
        bookmark.widthAnchor.constraint(lessThanOrEqualToConstant: iconWidth).isActive = true
        
        nameLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        skuLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: labelHeight).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        bookmark.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
    }
    
    func populate(item: Item) {
        nameLabel.text?.append(item.name ?? "")
        priceLabel.text?.append("\(item.price)")
        skuLabel.text?.append(item.sku ?? "")
        bookmark.isHidden = !item.isMarked
    }
    
    func updataBookmark(toMark: Bool) {
        bookmark.isHidden = !toMark
    }
}

extension ProductTableViewCell {
    var horizonMargin: CGFloat { 20 }
    var verticalMargin: CGFloat { 10 }
    var labelMaxWidth: CGFloat { 250 }
    var iconWidth: CGFloat { 30 }
    var labelHeight: CGFloat { 20 }
    var iconHeight: CGFloat { 10 }
    
    var prefixName: String { "Name: " }
    var prefixPrice: String { "Price: $ " }
    var prefixSku: String { "sku: " }
}
