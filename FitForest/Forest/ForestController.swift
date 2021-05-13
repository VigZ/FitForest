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
    var runyunStorage = RunyunCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    var runyunDetailView = RunyunDetailView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
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
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
            // Present the scene
            view.presentScene(scene)
            scene.viewController = self
            
            view.ignoresSiblingOrder = true

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
        guard let runyunStorageView = runyunStorage.collectionView else {return}
        
        let ns = NotificationCenter.default
        let shouldHideInventory = Notification.Name.ForestEvents.shouldHideInventory
        ns.addObserver(forName: shouldHideInventory, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.closeInventory()
                self.closeRunyunStorage()
                self.closeDetail()
            }
        }

        self.view.addSubview(inventoryView)
        self.view.addSubview(runyunStorageView)
        self.view.addSubview(runyunDetailView)
        
        let closeButton = UIButton(type: .close)
        let runyunCloseButton = UIButton(type: .close)
        let detailCloseButton = UIButton(type: .close)
        
        closeButton.addTarget(self, action: #selector(closeInventory), for: .touchUpInside)
        runyunCloseButton.addTarget(self, action: #selector(closeRunyunStorage), for: .touchUpInside)
        detailCloseButton.addTarget(self, action: #selector(closeDetail), for: .touchUpInside)
        
        
        inventoryView.addSubview(closeButton)
        runyunStorageView.addSubview(runyunCloseButton)
        runyunDetailView.addSubview(detailCloseButton)
        
        inventoryView.isHidden = true
        runyunStorageView.isHidden = true
        runyunDetailView.isHidden = true
        
       inventoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inventoryView.widthAnchor.constraint(equalToConstant: 300),
            inventoryView.heightAnchor.constraint(equalToConstant: 300),
            inventoryView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            inventoryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -400)
        ])
        
        runyunStorageView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             runyunStorageView.widthAnchor.constraint(equalToConstant: 300),
             runyunStorageView.heightAnchor.constraint(equalToConstant: 300),
             runyunStorageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
             runyunStorageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -400)
         ])
        
        runyunDetailView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            runyunDetailView.widthAnchor.constraint(equalToConstant: 300),
            runyunDetailView.heightAnchor.constraint(equalToConstant: 300),
            runyunDetailView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            runyunDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
        
        
    }
    
    @objc func closeInventory(){
        guard let inventoryView = uiInventory.collectionView else {return}
        inventoryView.isHidden = true
    }
    
    func showInventory(){
        guard let inventoryView = uiInventory.collectionView else {return}
        inventoryView.reloadData()
        inventoryView.isHidden = false
    }
    
    func showRunyunStorage(){
        guard let runyunView = runyunStorage.collectionView else {return}
        runyunView.reloadData()
        runyunView.isHidden = false
    }
    
    @objc func closeRunyunStorage(){
        guard let runyunView = runyunStorage.collectionView else {return}
        runyunView.isHidden = true
    }
    
    func updateRunyunDetail(runyun: RunyunStorageObject) {
        runyunDetailView.updateRunyun(runyun: runyun)
        runyunDetailView.isHidden = false
//        let baseConstraint = runyunDetail.topAnchor.constraint(equalTo: runyunDetail.topAnchor, constant: runyunDetail.bounds.height * 2)
//        runyunDetail.addConstraint(baseConstraint)
//        UIView.animate(withDuration: 0.3) {
//                runyunDetail.layoutIfNeeded()
//        }
        //TODO FIX SLIDING DRAWER. CHANGE FROM CENTER Y TO ENTIRE HEIGHT OF VIEW AND SLIDE UP AND DOWN
    
    }
    
    @objc func closeDetail(){
        runyunDetailView.isHidden = true
//        runyunDetailView.animHide()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 3.
//        view.bringSubviewToFront(uiInventory.collectionView)
    }
}
