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
                    //TODO Clean this up, setup physics uses weight value from item, but is called before the item was set here. Resorted to convienence init, should probably normalize.
                    let newNode = BallNode(name:underScoredName, item: item)
                    return newNode
                case is Instrument:
                    let newNode = InstrumentNode(name:underScoredName)
                    newNode.linkedInventoryItem = item as? Instrument
                    return newNode
                case is HidingSpot:
                    let newNode = HidingSpotNode(name:underScoredName)
                    newNode.linkedInventoryItem = item as? HidingSpot
                    return newNode
                case is Seed:
                    let seed = item as! Seed
                    let newNode = SeedNode(name:underScoredName, modifier: seed.modifier, seedType: seed.seedType )
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
