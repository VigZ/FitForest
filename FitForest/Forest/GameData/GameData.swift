//
//  GameData.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/12/21.
//

import Foundation
import SpriteKit

class GameData: NSObject, NSCoding {
    
    static var sharedInstance: GameData = GameData.loadFromDisk()
    
    var points: Int = 0
    var inventory: InventoryManager!

    var scene: ForestScene = SKScene(fileNamed: "ForestScene") as! ForestScene
    
    static func loadFromDisk() -> GameData {
        
        let url = getSaveDirectory()
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                let data = try Data(contentsOf: url)
                print(data)
                if let gameData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? GameData {
                    print("Loading Data...")
                    return gameData
                    
                }
            } else {
    
                FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        let newScene = SKScene(fileNamed: "ForestScene") as! ForestScene
        newScene.isInitialSetup = true
        let newInventory = InventoryManager(items:[Item](), runyunStorage: [RunyunStorageObject]())
        let newGameData = GameData(points: 0, inventory: newInventory, scene: newScene)
        newGameData.saveToDisk()
        print("Creating new save data...")
        return newGameData
        
    }
    
    func saveToDisk() {
        let url = GameData.getSaveDirectory()
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            
            try data.write(to: url)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        print("Successfully saved")
        
    }
    
    static func getSaveDirectory() -> URL {
        // find all possible documents directories for this user
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("gameData")

        return path
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.points, forKey: "points")
        coder.encode(self.inventory, forKey: "inventory")
        coder.encode(self.scene, forKey: "scene")
        
        NotificationCenter.default.removeObserver(self)
        print("removing observer")
    }
    
    init(points:Int, inventory:InventoryManager, scene:ForestScene ) {
        self.points = points
        self.inventory = inventory
        self.scene = scene
    }
    
    required convenience init?(coder: NSCoder) {
         let points = coder.decodeInteger(forKey:"points")
        guard let inventory = coder.decodeObject(forKey: "inventory") as? InventoryManager,
        let scene = coder.decodeObject(forKey: "scene") as? ForestScene
        
        else { return nil }
        print("Unpacking saved forest...")
        self.init(points:points,
                  inventory:inventory,
                  scene: scene)
        registerForNotifications()
    }
    
    private func registerForNotifications() {
        print("Registering for Notifications")
        let ns = NotificationCenter.default
        let itemPurchased = Notification.Name.StoreEvents.itemPurchased
        
        ns.addObserver(forName: itemPurchased, object: nil, queue: nil){
            (notification) in
            
            //(item, remainingPoints)
            
            // Subtract Points
            let object = notification.object as! (StoreItem, Int)
            self.points = object.1
            print("This is being reached \(object.1) points left")
        }
        
    }
    
}
 
