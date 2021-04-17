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
        setupUIView()
        
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
    
    func setupUIView(){
        guard let inventoryView = uiInventory.collectionView else {return}
        
        
        self.view.addSubview(inventoryView)
        let closeButton = UIButton(type: .close)
        closeButton.addTarget(self, action: #selector(closeInventory(sender:)), for: .touchUpInside)
        inventoryView.addSubview(closeButton)
        
        inventoryView.isHidden = true
        
       inventoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inventoryView.widthAnchor.constraint(equalToConstant: 300),
            inventoryView.heightAnchor.constraint(equalToConstant: 300),
            inventoryView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            inventoryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -400)
        ])
        
    }
    
    @objc func closeInventory(sender:UIButton){
        sender.superview!.isHidden = true
    }
    
    func showInventory(){
        guard let inventoryView = uiInventory.collectionView else {return}
        
        inventoryView.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 3.
        view.bringSubviewToFront(uiInventory.collectionView)
    }
}
