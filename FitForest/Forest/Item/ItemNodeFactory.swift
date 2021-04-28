//
//  ItemNodeFactory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/15/21.
//

import Foundation
import SpriteKit

class ItemNodeFactory {
    
    static var sharedInstance = ItemNodeFactory()
    
    func createItemNode(item : Item)-> SKSpriteNode?{
        let underScoredName = item.name.replacingOccurrences(of: " ", with: "_")
            switch item {
                case is Ball:
                    let newNode = BallNode(name:underScoredName)
                    newNode.linkedInventoryItem = item as? Ball
                    print(newNode.linkedInventoryItem)
                    return newNode
                case is Instrument:
                    let newNode = InstrumentNode(name:underScoredName)
                    newNode.linkedInventoryItem = item as? Instrument
                    return newNode
                case is Seed:
                    let newNode = SeedNode(name:underScoredName)
                    return newNode
                case is Accessory:
                    let newNode = AccessoryNode(name: underScoredName)
                    newNode.linkedInventoryItem = item as? Accessory
                    return newNode
                
            default:
                return nil
            }
        }
}
