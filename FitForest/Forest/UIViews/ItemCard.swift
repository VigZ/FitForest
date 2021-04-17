//
//  ItemCard.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/16/21.
//

import UIKit

class ItemCard: UICollectionViewCell {
    
    var item:Item!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    @objc func createNode(){
        guard let newNode = ItemNodeFactory.sharedInstance.createItemNode(item:self.item) else { return }
        GameData.sharedInstance.scene.addChild(newNode)
    }
}

