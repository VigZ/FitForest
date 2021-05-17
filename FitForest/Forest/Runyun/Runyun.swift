//
//  Runyun.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/1/21.
//

import Foundation
import SpriteKit

class Runyun: SKSpriteNode, Placeable {
    var isBeingMoved: Bool = false
    var runyunStorageObject: RunyunStorageObject
    var state: RunyunState! //TODO: Remove ability to drag and drop seedling state runyuns
    var accessory: AccessoryNode?
    var tokenObserver:NSObjectProtocol?
    var leaf: SKSpriteNode
    // TODO: Either turn runyun into SKNode with body and leaf sprite, or make sure that leaf as a child will still move the runyun when tapped and held.
    func pickedUp() {
        print("\(runyunStorageObject.seedling)")
        print(runyunStorageObject.observedStepsRemaining)
        print(tokenObserver)
        print(self.size)
        print(runyunStorageObject.leafType)
        print(runyunStorageObject.name)
        print(self.state.rawValue)
        
    }
    
    func putDown() {
        
    }
    

    init(runyunStorageObject: RunyunStorageObject, leaf: SKSpriteNode) {
        // Make a texture from an image, a color, and size
        let imageName = runyunStorageObject.seedling ? "seedling" : "runyunWalk_1"
        
        let texture = SKTexture(imageNamed: imageName)
        let color = UIColor.clear
        let size = CGSize(width: 100, height: 140)
        self.state = .idle
        self.runyunStorageObject = runyunStorageObject
        self.leaf = leaf
            
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)

        // Set physics properties
        
        self.zPosition = CGFloat(Depth.runyun.rawValue)
        leaf.size = CGSize(width: 100, height: 90)
        leaf.anchorPoint = CGPoint(x: 0.5, y: 0)
        leaf.position = CGPoint(x:self.position.x + 30 , y: self.position.y + 20)
        leaf.zPosition = CGFloat(Depth.leaf.rawValue)
        self.addChild(leaf)
        addStepObserver()
        if !runyunStorageObject.seedling {
            addPhysicsBody()
            setState(runyunState: .walking)
        }
        else {
            leaf.isHidden = true
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        guard let keyedDecoder = aDecoder as? NSKeyedUnarchiver else {
            fatalError("Must use Keyed Coding")
        }
        self.runyunStorageObject = (keyedDecoder.decodeObject(forKey: "runyunStorageObject") as? RunyunStorageObject)!
        self.state =  keyedDecoder.decodeDecodable(RunyunState.self, forKey: "state")
        self.leaf = keyedDecoder.decodeObject(forKey: "leaf") as? SKSpriteNode ?? SKSpriteNode(imageNamed: "standard_leaf")
        super.init(coder: aDecoder)
        addStepObserver()
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        guard let keyedCoder = aCoder as? NSKeyedArchiver else {
                    fatalError("Must use Keyed Coding")
                }
        keyedCoder.encode(self.runyunStorageObject, forKey: "runyunStorageObject")
        keyedCoder.encode(self.leaf, forKey: "leaf")
        try! keyedCoder.encodeEncodable(self.state, forKey: "state")
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
    }
    
    func hatch() {
        if let observer = tokenObserver {
            let ns = NotificationCenter.default
            ns.removeObserver(observer)
            tokenObserver = nil
        }
        self.runyunStorageObject.seedling = false
        leaf.isHidden = false
        self.runyunStorageObject.observedStepsRemaining = 0
        setState(runyunState: .walking)
        addPhysicsBody()
        print("A new Runyun has hatched!")
    }
    
    func showDetail() {
        let sceneController = self.scene?.view?.findViewController()
        if let sceneController = sceneController as? ForestController{
            sceneController.updateRunyunDetail(runyun:self.runyunStorageObject)
        }
    }
    
    func startBehavior() {
        guard runyunStorageObject.seedling != true else {return}
        removeAllActions()
        attachAnimation()
        attachActions()
        
    }
    func attachActions(){
        guard runyunStorageObject.seedling == false else {return}
        switch state {
        case .walking:
            let randomMoveAction = SKAction.run { [unowned self] in
                let xPosition = Double.random(in: -200...200)
                let yPosition = Double.random(in: -200...200)
                
                let xDelta = Double(self.position.x) + xPosition
                let yDelta = Double(self.position.y) + yPosition
                let randomPoint = CGPoint(x: xDelta, y: yDelta)
                
                let distance = sqrt(pow((randomPoint.x - self.position.x), 2.0) + pow((randomPoint.y - self.position.y), 2.0))
                
                let moveDuration = 0.03 * distance
                
                if xPosition > 0 {
                    self.run(SKAction.scaleX(to: -1.0, duration: 0.2))
                } else {
                    self.run(SKAction.scaleX(to: 1.0, duration: 0.2))
                }
                
                self.run(SKAction.move(to: randomPoint, duration: TimeInterval(moveDuration))){
                    self.setState(runyunState: .idle)
                }
            }
            self.run(randomMoveAction)
        case .interacting:
            self.run(SKAction.wait(forDuration: 3)){
                self.setState(runyunState: .walking)
            }
        case .idle:
            self.run(SKAction.wait(forDuration: 3)){
                self.setState(runyunState: .walking)
            }
        default:
            self.run(SKAction.wait(forDuration: 3))
        }
    }
    
    func attachAnimation(){
        self.texture = SKTexture(imageNamed: "runyun_default") //This workaround stops the flickering. Will need to be the first frame of the idle/interact.
        switch state {
        case .walking:
            let walkCycle = setupFrames(atlasName: "runyunWalk")
            self.run(SKAction.repeatForever(
                      SKAction.animate(with: walkCycle,
                                       timePerFrame: 0.1,
                                       resize: false,
                                       restore: true)),
                      withKey:"runyun_animation")
            
        case .idle:
            let idleCycle = setupFrames(atlasName: "runyunIdle")
            self.run(SKAction.repeatForever(
                      SKAction.animate(with: idleCycle,
                                       timePerFrame: 0.1,
                                       resize: false,
                                       restore: true)),
                      withKey:"runyun_animation")
        case .interacting:
            let interactCycle = setupFrames(atlasName: "runyunInteract")
            self.run(SKAction.repeatForever(
                      SKAction.animate(with: interactCycle,
                                       timePerFrame: 0.1,
                                       resize: false,
                                       restore: true)),
                      withKey:"runyun_animation")
            //May need to revisit this if the full animations cause the tiny flicker. Might be unavoidable though.
        default:
            self.texture = SKTexture(imageNamed: "runyunWalk_1")
        }
    }
    
    private func setupFrames(atlasName: String) -> [SKTexture]{
        
        let animationAtlas = SKTextureAtlas(named: atlasName)
        var frames: [SKTexture] = []

        let numImages = animationAtlas.textureNames.count
        for i in 1...numImages {
          let frameName = "\(atlasName)_\(i)"
          frames.append(animationAtlas.textureNamed(frameName))
        }
        
        return frames
    }
    
    func setState(runyunState: RunyunState){
        state = runyunState
        startBehavior()
    }
    
    func addPhysicsBody() {
        //TODO Could add the physics body to the seperate node like orginally had.
        self.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = CollisionCategory.DetectionCategory.rawValue
        self.physicsBody!.contactTestBitMask =  CollisionCategory.ItemCategory.rawValue
        self.physicsBody!.isDynamic = true
        
    }
    
    func moveToToy(toy: ToyNode){
        //Approach toy
        self.removeAllActions()
        self.state = .walking
        attachAnimation()
        let pointX = toy.position.x
        let distance = sqrt(pow((toy.position.x - self.position.x), 2.0) + pow((toy.position.y - self.position.y), 2.0))
        
        let moveDuration = 0.03 * distance
        print("Moving towards toy.")
        if pointX > self.position.x {
            self.run(SKAction.scaleX(to: -1.0, duration: 0.2))
        } else {
            self.run(SKAction.scaleX(to: 1.0, duration: 0.2))
        }
        self.run(SKAction.move(to: toy.position, duration: TimeInterval(moveDuration))){
            self.interact(toy: toy)
        }
        //Interact with toy
    }
    
    func createLeafNode(leafType: LeafType){
        
    }
    
    func interact(toy: ToyNode){
        print("Interacting!")
        setState(runyunState: .interacting)
        toy.unitInteract()
    }
    
    private func addStepObserver() {
        if self.runyunStorageObject.seedling {
            let ns = NotificationCenter.default
            let stepCountUpdated = Notification.Name.StepTrackerEvents.stepCountUpdated
            
            tokenObserver = ns.addObserver(forName: stepCountUpdated, object: nil, queue: nil){
                (notification) in
                DispatchQueue.main.async {
                    guard let steps = notification.userInfo?["steps"] as? Int else {return}
                    self.runyunStorageObject.observedStepsRemaining -= steps
                    print("\(self.runyunStorageObject.observedStepsRemaining) steps remaing")
                    
                    if self.runyunStorageObject.observedStepsRemaining <= 0 {
                        self.hatch()
                    }
                    
                    
                }
            }
        }
    }
}

