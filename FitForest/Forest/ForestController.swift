//
//  ForestController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/30/21.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class ForestController: UIViewController {
    
    var uiInventory = InventoryCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    override func loadView() {
      self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameData.sharedInstance.scene
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view.presentScene(scene)
           scene.viewController = self
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        uiInventory.modalPresentationStyle = .overCurrentContext
        present(uiInventory, animated: false, completion: nil)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
