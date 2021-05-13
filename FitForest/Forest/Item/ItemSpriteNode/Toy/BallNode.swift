//
//  BallNode.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation
import SpriteKit

class BallNode: SKSpriteNode, ToyNode, HasLinkedItem {
    
    var linkedInventoryItem: Item!
    
    var isBeingMoved: Bool = false
    
    init(name:String) {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: name)
        let color = UIColor.clear
        let size = texture.size()
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        self.name = name
        // Set physics properties
        setUpPhysics()
        self.zPosition = CGFloat(Depth.item.rawValue)
    }

    required init?(coder aDecoder: NSCoder) {
        self.linkedInventoryItem = aDecoder.decodeObject(forKey: "linkedInventoryItem") as? Item
        self.isBeingMoved = aDecoder.decodeBool(forKey: "isBeingMoved")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.linkedInventoryItem, forKey: "linkedInventoryItem")
        aCoder.encode(self.isBeingMoved, forKey: "isBeingMoved")
    }

    
    func pickedUp() {
        isBeingMoved = true
        print("Node has been picked up after a long press")
        // TODO Disable physics collisions
        
    }
    
    func putDown() {
        isBeingMoved = false
        print("Node has been put down after a long press")
        // TODO Reenable physics collions
    }
    
    func toggleLinkedItem(){
        guard let linkedInventoryItem = linkedInventoryItem else {return}
        linkedInventoryItem.itemState.toggle()
    }
    
    func setUpPhysics(){
        //TODO Set size to be texture size. Changing to hardcoded value for now until I recieve image assets.
        physicsBody = SKPhysicsBody(circleOfRadius: 100)
        physicsBody!.categoryBitMask = CollisionCategory.ItemCategory.rawValue
        physicsBody!.collisionBitMask = 0
        physicsBody!.contactTestBitMask = CollisionCategory.DetectionCategory.rawValue
        physicsBody!.affectedByGravity = false
        physicsBody!.isDynamic = true
    }

}


