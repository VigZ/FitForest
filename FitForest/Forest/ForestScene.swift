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
    
    typealias CompletionHandler = () -> Void
    
    var viewController: ForestController!
    var grabbedNode: SKSpriteNode?
    var isInitialSetup: Bool = false
    
    override func didMove(to view: SKView) {
        if isInitialSetup {
            initialSetup()
        }
        self.physicsWorld.contactDelegate = self
        for child in self.children {
            if let runyun = child as? Runyun {
                if !runyun.runyunStorageObject.seedling{
                    runyun.attachActions()
                }
            }
        }
        for child in self.children {
            if child is Runyun || child is ToyNode {
                if let node = child as? Runyun {
                    if !node.runyunStorageObject.seedling{
                        node.addPhysicsBody()
                        node.attachActions()
                    }
                }
                else if let node = child as? ToyNode {
                    node.setUpPhysics()
                }
                
            }
        }
//        let texture = SKTexture(imageNamed: "runyunwalk_1")
//        let color = UIColor.clear
//        let size = CGSize(width: 100, height: 140)
//        let sprite = Runyun()
//        sprite.texture = texture
//        sprite.color = color
//        sprite.size = size
//        sprite.zPosition = 1
//        let atlas = SKTextureAtlas(named: "RunyunWalkCycle")
//        let m1 = atlas.textureNamed("runyunwalk_1.png")
//        let m2 = atlas.textureNamed("runyunwalk_2.png")
//        let m3 = atlas.textureNamed("runyunwalk_3.png")
//        let m4 = atlas.textureNamed("runyunwalk_4.png")
//
//        let textures = [m1, m2, m3, m4]
//        let animation = SKAction.animate(with: textures, timePerFrame: 0.10)
//
//        let moveRight = SKAction.moveBy(x: 50, y:0, duration:1.0)
//        let moveLeft = SKAction.moveBy(x: -50, y:0, duration:1.0)
//        let moveUp = SKAction.moveBy(x: 0, y: 50, duration:1.0)
//        let moveDown = SKAction.moveBy(x: 0, y: -50, duration:1.0)
//        let pause = SKAction.wait(forDuration: 1.0)
//        let aboutFace = SKAction.run {
//            if sprite.xScale == 1 {
//                sprite.xScale = -1
//            }
//            else {
//                sprite.xScale = 1
//            }
//
//        }
//
//        let pauseAnimation = SKAction.run {
//            sprite.texture = SKTexture(imageNamed: "runyunwalk_1")
//        }
//        let moveLeftSequence = SKAction.sequence([pauseAnimation, pause, moveLeft, aboutFace])
//        let moveRightSequence = SKAction.sequence([pauseAnimation, pause, moveRight, aboutFace])
//        let walk = SKAction.sequence([moveLeftSequence, moveRightSequence])
//        sprite.color = UIColor.systemGreen
//        sprite.colorBlendFactor = 1
//
//        let endlessAction = SKAction.repeatForever(walk)
//        addChild(sprite)
//        sprite.run(SKAction.repeatForever(endlessAction))
//        sprite.run(SKAction.repeatForever(animation))
//
//        let testRunyun = TestRunyun()
//        testRunyun.body.size = CGSize(width: 60, height: 75)
//        testRunyun.leaves.size = CGSize(width: 60, height: 75)
//        testRunyun.position = CGPoint(x: frame.midX, y: frame.midY)
//        self.addChild(testRunyun)
        
//        let inventory = GameData.sharedInstance.inventory
//        let seed = Seed(stackLimit: 10, name: "Basic Red Seed", itemDescription: "Your basic red runyun seed", itemState: ItemState.inInventory, itemType: ItemType.consumable, modifier: .rare, seedType: .blue)
//        inventory?.addItem(item:seed)
        
//        let inventory = GameData.sharedInstance.inventory
//        inventory?.retrieveItemData(classIdentifier: "Seed", itemName: "Red Seed")
//        inventory?.retrieveItemData(classIdentifier: "Seed", itemName: "Red Seed")
//        inventory?.retrieveItemData(classIdentifier: "Seed", itemName: "Red Seed")
//        let atlas = SKTextureAtlas(named: "runyunWalk")
//        let f1 = atlas.textureNamed("runyun_walk_1")
//        let f2 = atlas.textureNamed("runyun_walk_2")
//        let f3 = atlas.textureNamed("runyun_walk_3")
//        let f4 = atlas.textureNamed("runyun_walk_4")
//        let f5 = atlas.textureNamed("runyun_walk_5")
//        let walkCycle = [f1, f2, f3, f4, f5]
//
//        let texture = SKTexture(imageNamed: "runyun_walk_1")
//        let color = UIColor.clear
//        let size = CGSize(width: 100, height: 140)
//        let sprite = Runyun(runyunStorageObject: GameData.sharedInstance.inventory.runyunStorage[0], leaf: nil)
//        sprite.texture = texture
//        sprite.color = color
//        sprite.size = size
//        sprite.zPosition = 1
//
//        let animation = SKAction.animate(with: walkCycle, timePerFrame: 0.10)
//        self.addChild(sprite)
//        sprite.run(SKAction.repeatForever(animation))
        
//        let inventory = GameData.sharedInstance.inventory
//        let sunglasses = Accessory(stackLimit: 3, name: "Sunglasses", itemDescription: "Sunglasses", itemState: ItemState.inInventory, itemType: ItemType.accessory, anchorPoint: CGPoint(x: 0, y: 0), runyunAnchorPoint: CGPoint(x: 0, y: 0))
//        inventory?.addItem(item:sunglasses)

        
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        for entity in nodes(at: touch.location(in: self)) {
            if entity is Runyun {
                if let entity = entity as? Runyun {
                    entity.pickedUp()
                }
            }
            if entity is PlayerInteractable {
                if let entity = entity as? PlayerInteractable {
                    entity.playerInteract()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO Fix snap to center after grabbing Placeable
        
        guard let touch = touches.first else {return}
        
        if self.grabbedNode == nil {
            for entity in nodes(at: touch.location(in: self)){
                if let entity = entity as? SKSpriteNode {
                    if let accessory = entity as? AccessoryNode {
                        if accessory.linkedRunyun != nil {
                            break
                        }
                    }
                    if entity is Placeable {
                        if let runyun = entity as? Runyun {
                            
                            if runyun.runyunStorageObject.seedling {
                                break
                            }
                        }
                        self.grabbedNode = entity
                        //TODO TRY ADDING PICKED UP ACTION HERE.
                        break
                    }
                }
            }
        }
        guard let node = self.grabbedNode else {
            return
        }
        if let node = node as? Runyun {
            node.removeAllActions()
            node.attachAnimation()
        }
        if let node = node as? ToyNode {
            resetPhysics(node: node)
        }
        node.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Check to see if there is a current grabbed node, if not look at nodes at the touch ended location, then do something.
        guard let grabbed = self.grabbedNode else {
            guard let touch = touches.first else {return}
            for entity in nodes(at: touch.location(in: self)) {
                if entity is Runyun {
                    if let entity = entity as? Runyun {
                        entity.showDetail()
                    }
                }
            }
            return
        }
        //Check all children. If the child intersects the grabbed node and is appropriate type, destroy the grabbed node.
            for child in self.children {
                if child is ItemChest {
                    if child.intersects(grabbed) && grabbed is ToyNode {
                        destroyNode(node: grabbed)
                    }
                }
                if child is RunyunStorageSpace {
                    if child.intersects(grabbed) && grabbed is Runyun {
                        destroyNode(node: grabbed)
                    }
                }
                // If child is Runyun, and intersects the grabbed node, and the grabbed node is an Accessory, attach accessory.
                if child is Runyun {
                    guard let runyun = child as? Runyun else {return}
                    if child.intersects(grabbed) && grabbed is AccessoryNode {
                        guard let grabbed = grabbed as? AccessoryNode else {return}
                        
                        grabbed.attachToRunyun(runyun: runyun)
                    }
                }
        }
        if let runyun = grabbed as? Runyun {
            runyun.removeAllActions()
//            dropNode(node: runyun, completion: runyun.attachActions)
            runyun.attachActions()
        }
//        else if let toy = grabbed as? ToyNode {
//            dropNode(node: toy, completion: nil)
//        }
        checkForContacts(spriteNode: grabbed)
        self.grabbedNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    func resetPhysics(node: SKSpriteNode){
        guard let body = node.physicsBody else {return}
        body.velocity = CGVector(dx: 0, dy: 0)
        body.angularVelocity = 0
        
    }
    func destroyNode(node:SKSpriteNode) {
        if let node = node as? HasLinkedItem {
            node.toggleLinkedItem()
        }
        else if let node = node as? Runyun {
            node.runyunStorageObject.locationState = .inInventory
        }
        node.removeFromParent()
    }
    
    private func initialSetup() {
        let background = SKSpriteNode(imageNamed: "placeholderbackground2")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        background.zPosition = CGFloat(Depth.background.rawValue)
        addChild(background)
        
//        let forestSprite = Runyun()
//        let forestSprite2 = Runyun()
//
//        forestSprite.position = CGPoint(x: frame.midX, y: frame.midY)
//        forestSprite.size = CGSize(width: 275, height: 200)
//        forestSprite2.position = CGPoint(x: frame.midX + 200, y: frame.midY - 200)
//        forestSprite2.size = CGSize(width: 275, height: 200)
//        forestSprite2.xScale = -1
//
//        self.addChild(forestSprite)
//        self.addChild(forestSprite2)
//
//        let moveRight = SKAction.moveBy(x: 50, y:0, duration:1.0)
//        let moveLeft = SKAction.moveBy(x: -50, y:0, duration:1.0)
//        let moveUp = SKAction.moveBy(x: 0, y: 50, duration:1.0)
//        let moveDown = SKAction.moveBy(x: 0, y: -50, duration:1.0)
//        let pause = SKAction.wait(forDuration: 1.0)
//        let bounceTo = SKAction.scale(to: 1.2, duration: 0.1)
//        let bounceFrom = SKAction.scale(to: 1, duration: 0.1)
//        let sequence = SKAction.sequence([bounceTo, bounceFrom, moveRight, pause, bounceTo, bounceFrom, moveUp, pause, bounceTo, bounceFrom, moveLeft, pause, bounceTo, bounceFrom, moveDown, pause])
//
//        let endlessAction = SKAction.repeatForever(sequence)
//        forestSprite.run(endlessAction)
        
        let test = Ball(stackLimit: 3, name: "Beach Ball", itemDescription: "Test", itemState: .inForest, itemType: .toy, weight: 2.0)
        GameData.sharedInstance.inventory.items.append(test)
        let ball = GameData.sharedInstance.inventory.items[0]
        let newBallNode = ItemNodeFactory.sharedInstance.createItemNode(item: ball)!
        newBallNode.position = CGPoint(x: frame.midX - 200, y: frame.midY + 200)
        newBallNode.size = CGSize(width: 100, height: 100)

        self.addChild(newBallNode)
        
        let inventory = GameData.sharedInstance.inventory
        inventory?.retrieveItemData(classIdentifier: "Seed", itemName: "Red Seed")
        inventory?.retrieveItemData(classIdentifier: "Seed", itemName: "Red Seed")
        inventory?.retrieveItemData(classIdentifier: "Seed", itemName: "Red Seed")
        
        let itemChest = ItemChest(name: "Item_Chest_Placeholder")
        itemChest.position = CGPoint(x: frame.minX + 200, y: frame.maxY - 200)
        itemChest.size = CGSize(width: 200, height: 200)
        
        let runyunStorage = RunyunStorageSpace(name: "treeStump")
        runyunStorage.position = CGPoint(x: frame.maxX - 200, y: frame.maxY - 200)
        runyunStorage.size = CGSize(width: 200, height: 200)
        
        self.addChild(itemChest)
        self.addChild(runyunStorage)
        self.isInitialSetup = false
        GameData.sharedInstance.saveToDisk()
    }
    
    func checkForContacts(spriteNode: SKSpriteNode){
        guard let physicsBody = spriteNode.physicsBody else {return}
        for body in physicsBody.allContactedBodies(){
            if spriteNode is Runyun {
                let spriteNode =  spriteNode as! Runyun
                if body.node is ToyNode {
                    spriteNode.moveToToy(toy: body.node as! ToyNode)
                    break
                }
            }
            if spriteNode is ToyNode {
                if body.node is Runyun {
                    let runyun = body.node as! Runyun
                    runyun.moveToToy(toy: spriteNode as! ToyNode)
                    break
                }
            }
            
        }
    }

    func dropNode(node:SKSpriteNode, completion: CompletionHandler?){
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: -60), duration: 0.2)
        if let completion = completion {
            node.run(moveAction){
                completion()
            }
        }
        else {
            node.run(moveAction)
        }

    }
    
    func pickupNode(node:SKSpriteNode){
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: -60), duration: 0.2)
        node.run(moveAction)
    }
}


extension ForestScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node == self.grabbedNode || contact.bodyB.node == self.grabbedNode {
           return
        }
        if contact.bodyA.node is Runyun && contact.bodyB.node is ToyNode {
            // Have Runyun enact approach and interact action.
            let runyun = contact.bodyA.node as! Runyun
            let toy = contact.bodyB.node as! ToyNode
            runyun.moveToToy(toy: toy)
           }
        else if contact.bodyB.node is Runyun && contact.bodyA.node is ToyNode {
            let runyun = contact.bodyB.node as! Runyun
            let toy = contact.bodyA.node as! ToyNode
            runyun.moveToToy(toy: toy)
        }
    }
}
