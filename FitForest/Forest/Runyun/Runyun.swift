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
        
    }
    
    func putDown() {
        
    }
    

    init(runyunStorageObject: RunyunStorageObject, leaf: SKSpriteNode?) {
        // Make a texture from an image, a color, and size
        
        let texture = SKTexture(imageNamed: "seedling")
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
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = 1
        if let newLeaf = self.leaf {
            self.addChild(newLeaf)
        }
        addStepObserver()

        
    }

    required init?(coder aDecoder: NSCoder) {
        guard let keyedDecoder = aDecoder as? NSKeyedUnarchiver else {
            fatalError("Must use Keyed Coding")
        }
        self.runyunStorageObject = (keyedDecoder.decodeObject(forKey: "runyunStorageObject") as? RunyunStorageObject)!
        self.state =  keyedDecoder.decodeDecodable(RunyunState.self, forKey: "state")
        super.init(coder: aDecoder)
        addStepObserver()
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        guard let keyedCoder = aCoder as? NSKeyedArchiver else {
                    fatalError("Must use Keyed Coding")
                }
        keyedCoder.encode(self.runyunStorageObject, forKey: "runyunStorageObject")
        try! keyedCoder.encodeEncodable(self.state, forKey: "state")
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
    }
    
    func hatch() {
        if let observer = tokenObserver {
            let ns = NotificationCenter.default
            ns.removeObserver(observer)
        }
        self.runyunStorageObject.seedling = false
        self.runyunStorageObject.observedStepsRemaining = 0
        print("A new Runyun has hatched!")
    }
    
    func showDetail() {
        let sceneController = self.scene?.view?.findViewController()
        if let sceneController = sceneController as? ForestController{
            sceneController.createRunyunDetail(runyun:self.runyunStorageObject)
        }
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

