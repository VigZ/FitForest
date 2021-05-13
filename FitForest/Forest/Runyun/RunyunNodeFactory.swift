//
//  RunyunFactory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/26/21.
//

import Foundation
import SpriteKit

class RunyunNodeFactory {
    static var sharedInstance = RunyunNodeFactory()
    
    func createRunyunNode(runyun : RunyunStorageObject)-> Runyun?{
        let newRunyun = Runyun(runyunStorageObject: runyun, leaf: nil)
        newRunyun.removeAllActions()
        newRunyun.attachAnimation()
        return newRunyun
    }
    
    func createFromSeed(seedType: SeedType, seedModifier: SeedModifier) -> Runyun? {
        // add switch for observed steps int based on seed type
        // create Loot Table for leaftype and assign
        guard let leafType = generateLeafType(seedModifier: seedModifier) else {return nil}
//        let leafNode = generateLeafNode()
        let newRSO = RunyunStorageObject(name: "", locationState: .inForest, accessory: nil, observedStepsRemaining: 100, seedType: seedType, leafType: leafType, seedling: true)
        GameData.sharedInstance.inventory.addRunyun(runyun: newRSO)
        let newRunyun = Runyun(runyunStorageObject: newRSO, leaf: nil)
        return newRunyun
    }
    
    func generateLeafType(seedModifier: SeedModifier) -> LeafType? {
        // Create LootTable with all leaf types
        // Pull one based on seed modifier.
        let fileName = seedModifier.rawValue.capitalized + "Leaf"
        
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let lootTable = LootTable(data: data)
                let leafData = lootTable?.pickRandomItem()
                if let leafData = leafData {
                    let identifier = leafData["identifier"] as! String
                    
                    
                    return LeafType(rawValue:identifier)
                }
                
            }
        }
        catch {
            print(error)
        }
        return nil
        
    }
    
//    func generateLeafNode() -> SKSpriteNode {
//        
//    }
        
}
