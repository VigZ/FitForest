//
//  ItemFactory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/14/21.
//

import Foundation

class ItemFactory {
    
    static var sharedInstance = ItemFactory()
    
    enum ItemClass {
        case Ball
//        case Instrument
    }
    
    func createItem(itemClass : ItemClass, data : [String: Any?])-> Item?{
            switch itemClass {
                case .Ball:
                    // extract data into class
                    guard let name = data["name"] as? String,
                    let stackLimit = data["stackLimit"] as? Int,
                    let itemDescription = data["itemDescription"] as? String,
                    let weight = data["weight"] as? Float
                    else {return nil}
                    return Ball(stackLimit: stackLimit, name: name, itemDescription: itemDescription, itemState: ItemState.inInventory, itemType: ItemType.toy, weight: weight)
//                case .Instrument:
//                    return
            }
        }
    
}
