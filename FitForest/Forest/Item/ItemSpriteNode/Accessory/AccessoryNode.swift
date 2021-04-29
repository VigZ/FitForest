//
//  AccessoryNode.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/27/21.
//

import Foundation
import SpriteKit

class AccessoryNode: SKSpriteNode, ToyNode, HasLinkedItem {
    
    var linkedInventoryItem: Item!
    weak var linkedRunyun: Runyun?
    
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
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = 1
        self.size = CGSize(width: 100, height: 100)
    }

    required init?(coder aDecoder: NSCoder) {
        self.linkedInventoryItem = aDecoder.decodeObject(forKey: "linkedInventoryItem") as? Item
        self.linkedRunyun = aDecoder.decodeObject(forKey: "linkedRunyun") as? Runyun
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.linkedInventoryItem, forKey: "linkedInventoryItem")
        aCoder.encode(self.linkedRunyun, forKey: "linkedRunyun")
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
    
    func attachToRunyun(runyun: Runyun) {
        guard let linkedInventoryItem = linkedInventoryItem as? Accessory else {return}
        linkedRunyun = runyun
        runyun.accessory = self
        position = linkedInventoryItem.runyunAnchorPoint
        move(toParent:runyun)
    }

}
