//
//  TestRunyun.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/23/21.
//

import Foundation

import Foundation
import SpriteKit

class TestRunyun: SKNode {
    var isBeingMoved: Bool = false
    var body: SKSpriteNode!
    var leaves: SKSpriteNode!
    
    func pickedUp() {
        
    }
    
    func putDown() {
        
    }
    

    override init() {
        // Make a texture from an image, a color, and size
        body = SKSpriteNode(imageNamed: "runyunfull")
        leaves = SKSpriteNode(imageNamed: "runyunnewleaves")
        leaves.anchorPoint = CGPoint(x: body.position.x, y: body.position.y)


        // Call the designated initializer
        super.init()

        // Set physics properties
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = 1
        addChild(body)
        addChild(leaves)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
    }
}
