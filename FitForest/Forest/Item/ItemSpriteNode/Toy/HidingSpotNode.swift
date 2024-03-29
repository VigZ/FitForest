//
//  HidingSpotNode.swift
//  FitForest
//
//  Created by Kyle Vigorito on 7/14/21.
//

import Foundation
import SpriteKit

class HidingSpotNode: SKSpriteNode, ToyNode, HasLinkedItem {
    
    var linkedInventoryItem: Item!
    
    var isBeingMoved: Bool = false
    
    var hiddenRunyun: Runyun?
    
    init(name:String) {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: name)
        let color = UIColor.clear
        let size = texture.size()
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        self.name = name
        // Set physics properties
        self.zPosition = CGFloat(Depth.item.rawValue)
        setUpPhysics()
    }
    
    convenience init(name: String, item: Item) {
        self.init(name: name)
        self.linkedInventoryItem = item
        setUpPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        self.linkedInventoryItem = aDecoder.decodeObject(forKey: "linkedInventoryItem") as? Item
        self.isBeingMoved = aDecoder.decodeBool(forKey: "isBeingMoved")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        cleanUp()
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
    }
    
    func hide(runyun: Runyun) {
        
        guard hiddenRunyun == nil else {
            return
        }
        // Hide runyun
        hiddenRunyun = runyun
        runyun.isHidden = true
        
        // Set runyun location to center of object.
        
        runyun.removeAllActions()
        runyun.position = self.position
        
        
    }
    
    func unhide() {
        // Unhide Runyun
        hiddenRunyun?.isHidden = false
        hiddenRunyun?.setState(runyunState: .walking)
        hiddenRunyun = nil
    }
    
    
    func unitInteract(unit: SKSpriteNode) {
        let runyun = unit as! Runyun
        hide(runyun: runyun)
    }
    
    func playerInteract(){
        unhide()
    }
    
    func cleanUp() {
        if hiddenRunyun != nil {
            unhide()
        }
    }

}
