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
    var grabbedNode: SKSpriteNode?
    var isInitialLoad: Bool = false
    
    override func didMove(to view: SKView) {
        
        if isInitialLoad {
            initialSetup()
        }
        
        let texture = SKTexture(imageNamed: "runyunwalk_1")
        let color = UIColor.clear
        let size = CGSize(width: 100, height: 140)
        let sprite = Runyun()
        sprite.texture = texture
        sprite.color = color
        sprite.size = size
        sprite.zPosition = 1
        let atlas = SKTextureAtlas(named: "RunyunWalkCycle")
        let m1 = atlas.textureNamed("runyunwalk_1.png")
        let m2 = atlas.textureNamed("runyunwalk_2.png")
        let m3 = atlas.textureNamed("runyunwalk_3.png")
        let m4 = atlas.textureNamed("runyunwalk_4.png")

        let textures = [m1, m2, m3, m4]
        let animation = SKAction.animate(with: textures, timePerFrame: 0.10)
        
        let moveRight = SKAction.moveBy(x: 50, y:0, duration:1.0)
        let moveLeft = SKAction.moveBy(x: -50, y:0, duration:1.0)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration:1.0)
        let moveDown = SKAction.moveBy(x: 0, y: -50, duration:1.0)
        let pause = SKAction.wait(forDuration: 1.0)
        let aboutFace = SKAction.run {
            if sprite.xScale == 1 {
                sprite.xScale = -1
            }
            else {
                sprite.xScale = 1
            }
           
        }
    
        let pauseAnimation = SKAction.run {
            sprite.texture = SKTexture(imageNamed: "runyunwalk_1")
        }
        let moveLeftSequence = SKAction.sequence([pauseAnimation, pause, moveLeft, aboutFace])
        let moveRightSequence = SKAction.sequence([pauseAnimation, pause, moveRight, aboutFace])
        let walk = SKAction.sequence([moveLeftSequence, moveRightSequence])
        sprite.color = UIColor.systemGreen
        sprite.colorBlendFactor = 1

        let endlessAction = SKAction.repeatForever(walk)
        addChild(sprite)
        sprite.run(SKAction.repeatForever(endlessAction))
        sprite.run(SKAction.repeatForever(animation))
        
        let testRunyun = TestRunyun()
        testRunyun.body.size = CGSize(width: 100, height: 100)
        testRunyun.leaves.size = CGSize(width: 100, height: 100)
        testRunyun.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(testRunyun)
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
                if let entity = entity as? SKSpriteNode {
                    if entity is Placeable {
                        self.grabbedNode = entity
                        break
                    }
                }
            }
        }
        guard let node = self.grabbedNode else {
            return
        }
        node.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let grabbed = self.grabbedNode else {return}
            for child in self.children {
                if child is ItemChest {
                    if child.intersects(grabbed) && grabbed is Toy{
                        destroyNode(node: grabbed)
                    }
                }
        }
        self.grabbedNode = nil
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func destroyNode(node:SKSpriteNode) {
        if let node = node as? HasLinkedItem {
            node.toggleLinkedItem()
        }
        node.removeFromParent()
    }
    
    private func initialSetup() {
        let background = SKSpriteNode(imageNamed: "placeholderbackground2")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        background.zPosition = -200
        addChild(background)
        
        let forestSprite = Runyun()
        let forestSprite2 = Runyun()
        
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
        
        let test = Ball(stackLimit: 3, name: "Beach Ball", itemDescription: "Test", itemState: .inForest, itemType: .toy, weight: 2.0)
        GameData.sharedInstance.inventory.items.append(test)
        let ball = GameData.sharedInstance.inventory.items[0]
        let newBallNode = ItemNodeFactory.sharedInstance.createItemNode(item: ball)!
        newBallNode.position = CGPoint(x: frame.midX - 200, y: frame.midY + 200)
        newBallNode.size = CGSize(width: 100, height: 100)

        self.addChild(newBallNode)
        
        let itemChest = ItemChest(name: "Item_Chest_Placeholder")
        itemChest.position = CGPoint(x: frame.midX - 100, y: frame.maxY - 300)
        itemChest.size = CGSize(width: 200, height: 200)
        
        self.addChild(itemChest)
        isInitialLoad = false
    }
    
}
