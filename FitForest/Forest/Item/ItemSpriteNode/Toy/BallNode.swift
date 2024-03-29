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
    
    func bounce() {
        //TODO Adjust formula and weight/mass for balls accordingly to get desired effect. Could alwyas switch back to timer based end of animation.
        if self.physicsBody?.velocity == CGVector(dx: 0, dy: 0) {
            // needs to apply impulse base on weight of ball, and in choose random direction.
                let randX = Int.random(in: -100...100)
                let randY = Int.random(in: -100...100)
                physicsBody?.applyImpulse(CGVector(dx: randX, dy: randY))
                physicsBody!.applyAngularImpulse(2.0)
                physicsBody!.angularDamping = 0.4
                physicsBody!.friction = 1.0
        }
    }
    
    func unitInteract(unit: SKSpriteNode) {
        bounce()
    }
    
    func playerInteract(){
        bounce()
    }

}


