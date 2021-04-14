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
//        case Instrument
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
                    return Ball(stackLimit: stackLimit, name: name, itemDescription: itemDescription, itemState: ItemState.inInventory, itemType: ItemType.toy, weight: weight)
//                case .Instrument:
//                    return
            }
        }
    
}
