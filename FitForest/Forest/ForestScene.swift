//
//  ForestScene.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/30/21.
//

import Foundation
import SpriteKit
import GameplayKit

class ForestScene: SKScene {
    
    var viewController: ForestController!
    var grabbedNode: SKNode?
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "placeholderbackground2")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        background.zPosition = -200
        addChild(background)
        
        let forestSprite = ForestSprite()
        let forestSprite2 = ForestSprite()
        
        forestSprite.position = CGPoint(x: frame.midX, y: frame.midY)
        forestSprite.size = CGSize(width: 275, height: 200)
        forestSprite2.position = CGPoint(x: frame.midX + 200, y: frame.midY - 200)
        forestSprite2.size = CGSize(width: 275, height: 200)
        forestSprite2.xScale = -1
        
        self.addChild(forestSprite)
        self.addChild(forestSprite2)
        
        let moveRight = SKAction.moveBy(x: 50, y:0, duration:1.0)
        let moveLeft = SKAction.moveBy(x: -50, y:0, duration:1.0)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration:1.0)
        let moveDown = SKAction.moveBy(x: 0, y: -50, duration:1.0)
        let pause = SKAction.wait(forDuration: 1.0)
        let bounceTo = SKAction.scale(to: 1.2, duration: 0.1)
        let bounceFrom = SKAction.scale(to: 1, duration: 0.1)
        let sequence = SKAction.sequence([bounceTo, bounceFrom, moveRight, pause, bounceTo, bounceFrom, moveUp, pause, bounceTo, bounceFrom, moveLeft, pause, bounceTo, bounceFrom, moveDown, pause])

        let endlessAction = SKAction.repeatForever(sequence)
        forestSprite.run(endlessAction)
        
        let ball = GameData.sharedInstance.inventory.items[2]
        let newBallNode = ItemNodeFactory.sharedInstance.createItemNode(item: ball)!
        newBallNode.position = CGPoint(x: frame.midX - 200, y: frame.midY + 200)
        newBallNode.size = CGSize(width: 100, height: 100)
        
        self.addChild(newBallNode)
        
        let itemChest = ItemChest(name: "Item_Chest_Placeholder")
        itemChest.position = CGPoint(x: frame.midX - 100, y: frame.maxY - 300)
        itemChest.size = CGSize(width: 200, height: 200)
        itemChest.sceneController = self.view?.next as! ForestController // TODO Change this monstrosity
        
        self.addChild(itemChest)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO Fix snap to center after grabbing Placeable
        
        guard let touch = touches.first else {return}
        
        if self.grabbedNode == nil {
            for entity in nodes(at: touch.location(in: self)){
                if entity is Placeable {
                    self.grabbedNode = entity
                    break
                }
            }
        }
        guard let node = self.grabbedNode else {
            return
        }
        node.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.grabbedNode == nil {
            
        }
        self.grabbedNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}
