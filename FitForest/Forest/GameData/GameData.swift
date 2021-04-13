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
    var inventory: [String: Int] = [:]


    var scene: ForestScene = ForestScene()
    
    static func loadFromDisk() -> GameData {
        let url = getSaveDirectory()
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                let data = try Data(contentsOf: url)
                
                if let gameData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? GameData {
                    
                    return gameData
                    
                }
            } else {
    
                FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
            }
        } catch {
            
            print("ERROR: \(error.localizedDescription)")
        }
        
        let newGameData = GameData(points: 0, inventory: [:], scene: ForestScene())
        newGameData.saveToDisk()
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
    }
    
    init(points:Int, inventory:[String: Int], scene:ForestScene ) {
        self.points = points
        self.inventory = inventory
        self.scene = scene
    }
    
    required convenience init?(coder: NSCoder) {
         let points = coder.decodeInteger(forKey:"points")
        guard let inventory = coder.decodeObject(forKey: "inventory") as? Dictionary<String, Int>,
        let scene = coder.decodeObject(forKey: "scene") as? ForestScene
        
        else { return nil }

        self.init(points:points,
                  inventory:inventory,
                  scene: scene)
    }
}
 
