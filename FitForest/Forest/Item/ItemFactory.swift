//
//  ItemFactory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/14/21.
//

import Foundation
import CoreGraphics

class ItemFactory {
    
    static var sharedInstance = ItemFactory()
    
    enum ItemClass:String {
        case Ball
        case Instrument
        case Seed
        case Accessory
    }
    
    func createItem(itemClass : String, data : [String: Any?])-> Item?{
        
        guard let itemEnumClass = ItemClass(rawValue: itemClass) else {return nil}
            switch itemEnumClass {
                case .Ball:
                    // extract data into class
                    guard let name = data["name"] as? String,
                    let stackLimit = data["stackLimit"] as? Int,
                    let itemDescription = data["itemDescription"] as? String,
                    let weight = data["weight"] as? Float
                    else {return nil}
                    // Check current instances, if equal to or greater stackLimit, bail
                    if isAtStackLimit(target: name, stackLimit: stackLimit){
                        return nil
                    }
                    // otherwise create new Item
                    return Ball(stackLimit: stackLimit, name: name, itemDescription: itemDescription, itemState: ItemState.inInventory, itemType: ItemType.toy, weight: weight)
                    
                case .Instrument:
                    // extract data into class
                    guard let name = data["name"] as? String,
                    let stackLimit = data["stackLimit"] as? Int,
                    let itemDescription = data["itemDescription"] as? String
                    else {return nil}
                    // Check current instances, if equal to or greater stackLimit, bail
                    if isAtStackLimit(target: name, stackLimit: stackLimit){
                        return nil
                    }
                    // otherwise create new Item
                    return Instrument(stackLimit: stackLimit, name: name, itemDescription: itemDescription, itemState: ItemState.inInventory, itemType: ItemType.toy)
                case .Seed:
                    // extract data into class
                    guard let name = data["name"] as? String,
                    let stackLimit = data["stackLimit"] as? Int,
                    let itemDescription = data["itemDescription"] as? String,
                    let modifier =  data["modifier"] as? String,
                    let seedType = data["seedType"] as? String
                    else {return nil}
                    // Check current instances, if equal to or greater stackLimit, bail
                    if isAtStackLimit(target: name, stackLimit: stackLimit){
                        return nil
                    }
                    let convertedSeedType = SeedType(rawValue: seedType) ?? SeedType.red
                    let convertedSeedModifier = SeedModifier(rawValue: modifier) ?? SeedModifier.basic
                    // otherwise create new Item
                    print("\(convertedSeedType.rawValue) was set in item factory")
                    
                    return Seed(stackLimit: stackLimit, name: name, itemDescription: itemDescription, itemState: ItemState.inInventory, itemType: ItemType.consumable, modifier: convertedSeedModifier, seedType: convertedSeedType)
                case .Accessory:
                    // extract data into class
                    guard let name = data["name"] as? String,
                    let stackLimit = data["stackLimit"] as? Int,
                    let itemDescription = data["itemDescription"] as? String,
                    let anchorPoint = data["anchorPoint"] as? Array<Int>,
                    let runyunAnchorPoint = data["runyunAnchorPoint"] as? Array<Int>
                    else {return nil}
                    // Check current instances, if equal to or greater stackLimit, bail
                    if isAtStackLimit(target: name, stackLimit: stackLimit){
                        return nil
                    }
                    // Convert anchor points to CGPoint
                    let convertedAnchor = CGPoint(x: anchorPoint[0], y: anchorPoint[1])
                    let convertedRunyunAnchor = CGPoint(x: runyunAnchorPoint[0], y: runyunAnchorPoint[1])
                    // otherwise create new Item
                    return Accessory(stackLimit: stackLimit, name: name, itemDescription: itemDescription, itemState: ItemState.inInventory, itemType: ItemType.accessory, anchorPoint: convertedAnchor, runyunAnchorPoint: convertedRunyunAnchor)
            }
        }
    func isAtStackLimit(target:String, stackLimit: Int) -> Bool {
        // Count instances
        let array = GameData.sharedInstance.inventory.items
        var count = 0
        for item in array {
            if item.name == target{
                count += 1
            }
        }
        return count >= stackLimit
    }
}
