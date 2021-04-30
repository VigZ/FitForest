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
    var state: RunyunState!
    var accessory: AccessoryNode?
    var observedStepsRemaining: Int
    var tokenObserver:NSObjectProtocol?
    
    func pickedUp() {
    }
    
    func putDown() {
        
    }
    

    init() {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "runyun")
        let color = UIColor.clear
        let size = texture.size()
        self.state = RunyunState.seedling
        self.observedStepsRemaining = 100
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)

        // Set physics properties
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody?.categoryBitMask = 1
//        physicsBody?.affectedByGravity = false
        self.zPosition = 1
        addStepObserver()

        
    }

    required init?(coder aDecoder: NSCoder) {
        self.observedStepsRemaining = aDecoder.decodeInteger(forKey: "observedStepsRemaining")
        self.state = aDecoder.decodeObject(forKey: state.rawValue) as? RunyunState
        super.init(coder: aDecoder)
        addStepObserver()
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.observedStepsRemaining, forKey: "observedStepsRemaining")
        aCoder.encode(self.state, forKey: "state")
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
    }
    
    func hatch() {
        if let observer = tokenObserver {
            let ns = NotificationCenter.default
            ns.removeObserver(observer)
        }
        self.state = .idle
        print("A new Runyun has hatched!")
    }
    
    private func addStepObserver() {
        if self.state == .seedling {
            let ns = NotificationCenter.default
            let stepCountUpdated = Notification.Name.StepTrackerEvents.stepCountUpdated
            
            tokenObserver = ns.addObserver(forName: stepCountUpdated, object: nil, queue: nil){
                (notification) in
                DispatchQueue.main.async {
                    guard let steps = notification.userInfo?["steps"] as? Int else {return}
                    self.observedStepsRemaining -= steps
                    print("\(self.observedStepsRemaining) steps remaing")
                    
                    if self.observedStepsRemaining <= 0 {
                        self.hatch()
                    }
                    
                    
                }
            }
        }
    }
}

