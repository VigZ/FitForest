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
    
    @objc func createNode(_ gesture: UIGestureRecognizer){
        let location = gesture.location(in: gesture.view?.window)
        let scene = GameData.sharedInstance.scene

        let newPoint = scene.convertPoint(fromView: location)
        
        if gesture.state == .began {
            guard let newNode = ItemNodeFactory.sharedInstance.createItemNode(item:self.item) else { return }
            newNode.size = CGSize(width: 100, height: 100)
            newNode.position = newPoint
            scene.addChild(newNode)
            scene.grabbedNode = newNode
            NotificationCenter.default.post(name: Notification.Name.ForestEvents.shouldHideInventory, object: nil)
        }
        else if gesture.state == .changed {
            guard let grabbed = scene.grabbedNode else {return}
            grabbed.position = newPoint
            // Add location conversion here.
            
        }
        else if gesture.state == .ended {
            scene.grabbedNode = nil
        }
    }
}

