//
//  ItemFactory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/14/21.
//

import Foundation

class ItemFactory {
    
    static var sharedInstance = ItemFactory()
    
    enum ItemClass:String {
        case Ball
        case Instrument
        case Seed
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
                let itemDescription = data["itemDescription"] as? String
                else {return nil}
                // Check current instances, if equal to or greater stackLimit, bail
                if isAtStackLimit(target: name, stackLimit: stackLimit){
                    return nil
                }
                // otherwise create new Item
                return Seed(stackLimit: stackLimit, name: name, itemDescription: itemDescription, itemState: ItemState.inInventory, itemType: ItemType.consumable)
                  
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
