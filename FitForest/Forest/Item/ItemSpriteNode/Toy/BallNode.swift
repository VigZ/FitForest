//
//  BallNode.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation
import SpriteKit

class BallNode: SKSpriteNode, Toy {

    init() {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "runyun")
        let color = UIColor.clear
        let size = texture.size()

        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)

        // Set physics properties
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


