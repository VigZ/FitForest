//
//  ViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/23/21.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController, HasCustomView {
    typealias CustomView = MainView
    
    var lootTable: LootTable?
    
    override func loadView() {
        let customView = CustomView()
        customView.delegate = self
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        FitForestHealthStore.sharedInstance.requestUserPermissions()
        StepTracker.sharedInstance.startUpdating()
        do {
            if let file = Bundle.main.url(forResource: "DefaultLootTable", withExtension: "json") {
                let data = try Data(contentsOf: file)
            lootTable = LootTable(data: data)
                
            }
        }
        catch {
            print(error)
        }
        
    }
    
    private func registerForNotifications() {
        let ns = NotificationCenter.default
        let stepCountUpdated = Notification.Name.StepTrackerEvents.stepCountUpdated
        let storeItemBought = Notification.Name.StoreEvents.itemPurchased
        
        ns.addObserver(forName: stepCountUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.customView.topContainer.stepsLabel.text = String(StepTracker.sharedInstance.numberOfSteps)
                self.customView.topContainer.stateLabel.text = StepTracker.sharedInstance.currentActivity
                self.customView.topContainer.pointsLabel.text = String(GameData.sharedInstance.points)
                self.checkItemDrop()
            }
        }
        
        ns.addObserver(forName: storeItemBought, object: nil, queue: nil) {
            (notification) in
            let object = notification.object as! (StoreItem, Int)
            DispatchQueue.main.async {
                self.customView.topContainer.pointsLabel.text = String(object.1)
            }
        }
        
    }
    
    func checkItemDrop(){

        let randomNumber = Int.random(in: 1..<100)
        let inventory = GameData.sharedInstance.inventory

        
        if randomNumber <= 10 {
            let itemData = lootTable?.pickRandomItem()
            if let itemData = itemData {
                let name = itemData["name"] as! String
                let identifier = itemData["classIdentifier"] as! String
                if let inventory = inventory {
                    inventory.retrieveItemData(classIdentifier: identifier, itemName: name)
                }
            }
        }
    }


}

