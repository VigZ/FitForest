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
        physicsBody!.allowsRotation = true
        let ballItem = linkedInventoryItem as! Ball
        physicsBody!.mass = CGFloat(ballItem.weight)
    }
    
    func hide(runyun: Runyun) {
        // Hide runyun
    }
    
    func unhide() {
        // Unhide Runyun
    }
    
    
    func unitInteract(unit: SKSpriteNode) {
        let runyun = unit as! Runyun
        hide(runyun: runyun)
    }
    
    func playerInteract(){
        unhide()
    }

}
