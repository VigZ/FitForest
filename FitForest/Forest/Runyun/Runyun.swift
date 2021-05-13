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
    var leaf: SKSpriteNode!
    // TODO: Either turn runyun into SKNode with body and leaf sprite, or make sure that leaf as a child will still move the runyun when tapped and held.
    func pickedUp() {
        print("\(runyunStorageObject.seedling)")
        print(runyunStorageObject.observedStepsRemaining)
        print(tokenObserver)
        print(self.size)
        print(runyunStorageObject.leafType)
        print(runyunStorageObject.name)
        
    }
    
    func putDown() {
        
    }
    

    init(runyunStorageObject: RunyunStorageObject, leaf: SKSpriteNode?) {
        // Make a texture from an image, a color, and size
        let imageName = runyunStorageObject.seedling ? "seedling" : "runyun_walk_1"
        let texture = SKTexture(imageNamed: imageName)
        let color = UIColor.clear
        let size = CGSize(width: 100, height: 140)
        self.state = .idle
        self.runyunStorageObject = runyunStorageObject
        if let leaf = leaf {
            self.leaf = leaf
            
        }
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)

        // Set physics properties
        addPhysicsBody()
        
        self.zPosition = 1
        if let newLeaf = self.leaf {
            self.addChild(newLeaf)
        }
        addStepObserver()
        attachActions()

        
    }

    required init?(coder aDecoder: NSCoder) {
        guard let keyedDecoder = aDecoder as? NSKeyedUnarchiver else {
            fatalError("Must use Keyed Coding")
        }
        self.runyunStorageObject = (keyedDecoder.decodeObject(forKey: "runyunStorageObject") as? RunyunStorageObject)!
        self.state =  keyedDecoder.decodeDecodable(RunyunState.self, forKey: "state")
        super.init(coder: aDecoder)
        addPhysicsBody()
        addStepObserver()
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        guard let keyedCoder = aCoder as? NSKeyedArchiver else {
                    fatalError("Must use Keyed Coding")
                }
        keyedCoder.encode(self.runyunStorageObject, forKey: "runyunStorageObject")
        try! keyedCoder.encodeEncodable(self.state, forKey: "state")
        self.removeAllActions()
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
        self.runyunStorageObject.observedStepsRemaining = 0
        self.texture = SKTexture(imageNamed: "runyun_walk_1")
        self.attachActions()
        print("A new Runyun has hatched!")
    }
    
    func showDetail() {
        let sceneController = self.scene?.view?.findViewController()
        if let sceneController = sceneController as? ForestController{
            sceneController.updateRunyunDetail(runyun:self.runyunStorageObject)
        }
    }
    
    func attachActions(){
        
        guard runyunStorageObject.seedling != true else {return}
        

        attachAnimation()
        let waitAction = SKAction.wait(forDuration: 5.0, withRange: 3.5)
        
        let randomMoveAction = SKAction.run { [unowned self] in
            let xPosition = Double.random(in: -200...200)
            let yPosition = Double.random(in: -200...200)
            
            let xDelta = Double(self.position.x) + xPosition
            let yDelta = Double(self.position.y) + yPosition
//            let xPosition = CGFloat(arc4random_uniform(UInt32((self.scene?.frame.maxX)! + 1)))
//            let yPosition = CGFloat(arc4random_uniform(UInt32((self.scene?.frame.maxY)! + 1)))
            let randomPoint = CGPoint(x: xDelta, y: yDelta)
            
            let distance = sqrt(pow((randomPoint.x - self.position.x), 2.0) + pow((randomPoint.y - self.position.y), 2.0))
            
            let moveDuration = 0.03 * distance
            
            if xPosition > 0 {
                self.run(SKAction.scaleX(to: -1.0, duration: 0.2))
            } else {
                self.run(SKAction.scaleX(to: 1.0, duration: 0.2))
            }
            
            self.run(SKAction.move(to: randomPoint, duration: TimeInterval(moveDuration))){
                print("End of move")
            }
            //TODO Might be "jumping" because of the speed at which the action completes isn't consistent with the actual movement. After testing this seems to be the case. Fix this in the future.
            
            
        }
        
        let sequence = SKAction.sequence([randomMoveAction, waitAction])
        let endlessSequence = SKAction.repeatForever(sequence)
        self.run(endlessSequence)
        
    }
    
    func attachAnimation(){
        switch state {
        case .walking:
            let walkCycle = setupFrames()
            self.run(SKAction.repeatForever(
                      SKAction.animate(with: walkCycle,
                                       timePerFrame: 0.1,
                                       resize: false,
                                       restore: true)),
                      withKey:"runyun_animation")
            
        default:
            let walkCycle = setupFrames()
            self.run(SKAction.repeatForever(
                      SKAction.animate(with: walkCycle,
                                       timePerFrame: 0.1,
                                       resize: false,
                                       restore: true)),
                      withKey:"runyun_animation")
        }
    }
    
    private func setupFrames() -> [SKTexture]{
        
        let runyunWalk = SKTextureAtlas(named: "runyunWalk")
        var walkFrames: [SKTexture] = []

        let numImages = runyunWalk.textureNames.count
        for i in 1...numImages {
          let frameName = "runyun_walk_\(i)"
          walkFrames.append(runyunWalk.textureNamed(frameName))
        }
        
        return walkFrames


//        let averageDelay:TimeInterval = 2.0
//        let delayRange:TimeInterval = 1.0
//
//        let delayMove = SKAction.wait(forDuration:averageDelay, withRange:delayRange)
        
        
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
    
    func interact(toy: ToyNode){
        print("Interacting!")
        self.attachActions()
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

