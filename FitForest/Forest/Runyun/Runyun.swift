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
        if self.state == .seedling {
            let ns = NotificationCenter.default
            let stepCountUpdated = Notification.Name.StepTrackerEvents.stepCountUpdated
            
            ns.addObserver(forName: stepCountUpdated, object: nil, queue: nil){
                (notification) in
                DispatchQueue.main.async {
                    guard let steps = notification.userInfo?["steps"] as? Int else {return}
                    self.observedStepsRemaining -= steps
                    print("Just added \(steps) steps.")
                    
                    if self.observedStepsRemaining <= 0 {
                        self.state = .idle
                        print("A new Runyun has hatched!")
                        ns.removeObserver(self)
                    }
                    
                    
                }
            }
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        self.observedStepsRemaining = aDecoder.decodeInteger(forKey: "observedStepsRemaining")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.observedStepsRemaining, forKey: "observedStepsRemaining")
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
    }
}

