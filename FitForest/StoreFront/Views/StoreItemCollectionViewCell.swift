//
//  StoreItemCollectionViewCell.swift
//  FitForest
//
//  Created by Kyle Vigorito on 9/7/21.
//

import UIKit

class StoreItemCollectionViewCell: UICollectionViewCell {
    
    var storeItem:StoreItem!
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageView: UIImageView = {
        let image = UIImage(named: "runyun.jpeg")!
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(nameLabel)

        // add corner radius on `contentView`
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 8

        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
