//
//  SeedNode.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/27/21.
//

import Foundation
import SpriteKit

class SeedNode: SKSpriteNode, Placeable, ConsumableNode {
    
    var isBeingMoved: Bool = false
    var modifier: SeedModifier = .basic
    var seedType: SeedType = .red
    
    init(name:String, modifier:SeedModifier, seedType: SeedType) {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: name)
        let color = UIColor.clear
        let size = texture.size()
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        self.name = name
        self.modifier = modifier
        self.seedType = seedType
        // Set physics properties
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func spawnRunyun() {
        // Use Runyun Factory
        let currentLocation = self.position
        guard let newRunyun = RunyunNodeFactory.sharedInstance.createFromSeed(seedType: self.seedType, seedModifier: self.modifier) else {return}
        newRunyun.position = currentLocation
        scene?.addChild(newRunyun)
    }
    
    func consume() {
        print(seedType)
        spawnRunyun()
    }
    
}
