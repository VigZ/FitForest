//
//  ItemChest.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/17/21.
//

import Foundation
import SpriteKit

class ItemChest: SKSpriteNode, HotSpot {
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
            // Can not be set.
        }
    }
    
    init(name:String) {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: name)
        let color = UIColor.clear
        let size = texture.size()

        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)

        // Set physics properties
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = -199
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sceneController = self.scene?.view?.findViewController()
        if let sceneController = sceneController as? ForestController{
            sceneController.showInventory()
        }
       
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func playerInteract() {
        
    }


}
