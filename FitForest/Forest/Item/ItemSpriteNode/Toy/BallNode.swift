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
        physicsBody!.allowsRotation = true
        let ballItem = linkedInventoryItem as! Ball
        physicsBody!.mass = CGFloat(ballItem.weight)
    }
    
    func bounce() {
        // needs to apply impulse base on weight of ball, and in choose random direction.
        if !isBeingMoved{
            isBeingMoved = true
            let randX = Int.random(in: -100...100)
            let randY = Int.random(in: -100...100)
            physicsBody?.applyImpulse(CGVector(dx: randX, dy: randY))
            let fullRotation: Float =  .pi * 2
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { timer in
                self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                timer.invalidate()
                self.isBeingMoved = false
            }
            let rotate =  SKAction.rotate(byAngle: CGFloat(fullRotation), duration: 4)
            self.run(rotate)
        }

    }
    
    func unitInteract() {
        bounce()
    }
    
    func playerInteract(){
        bounce()
    }

}


