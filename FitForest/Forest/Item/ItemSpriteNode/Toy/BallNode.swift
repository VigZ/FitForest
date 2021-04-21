//
//  BallNode.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation
import SpriteKit

class BallNode: SKSpriteNode, Toy, HasLinkedItem {
    
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
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if isBeingMoved {
//            //Drag Code
//            print("Touches began")
//
//        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
////            //Drag Code
////            print("Touches are being moved")
////            let touch = touches.first
////            if let location = touch?.location(in: self){
////                self.position = location
////            }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        putDown()
//    }
    
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
        linkedInventoryItem.itemState.toggle()
    }

}


