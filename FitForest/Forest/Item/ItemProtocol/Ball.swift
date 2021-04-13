//
//  Ball.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation
import SpriteKit

class Ball: SKSpriteNode, Item {
    
    var stackLimit:Int
    var itemType: ItemType
    var weight: Int
    
    
    init(stackLimit:Int ,name: String, itemType:ItemType, description: String, sprite: SKTexture, weight: Int) {
        
        let texture = sprite
        let color = UIColor.clear
        let size = texture.size()
        
        super.init(texture: texture, color: color, size: size)
        self.stackLimit = stackLimit
        self.itemType = itemType
        self.weight = weight
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bounce(){
        
    }
    func roll(direction: CGVector) {
        
    }
}
