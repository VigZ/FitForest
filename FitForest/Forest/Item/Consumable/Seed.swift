//
//  Seed.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/26/21.
//

import Foundation

class Seed: NSObject, NSCoding , Item, Consumable  {
    var stackLimit:Int = 10
    var name: String
    var itemDescription: String = ""
    var itemState: ItemState = .inInventory
    var itemType: ItemType = .consumable
    var modifier: String = ""
    
    init(stackLimit:Int ,name: String, itemDescription: String, itemState: ItemState, itemType: ItemType, modifier: String) {
        self.stackLimit = stackLimit
        self.name = name
        self.itemDescription = itemDescription
        self.itemState = itemState
        self.itemType = itemType
        self.modifier = modifier
    }
    
    func encode(with coder: NSCoder) {
        guard let keyedCoder = coder as? NSKeyedArchiver else {
                    fatalError("Must use Keyed Coding")
                }
        coder.encode(self.stackLimit, forKey: "stackLimit")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.itemDescription, forKey: "itemDescription")
        coder.encode(self.modifier, forKey: "modifier")
        try! keyedCoder.encodeEncodable(self.itemState, forKey: "itemState")
        try! keyedCoder.encodeEncodable(self.itemType, forKey: "itemType")
    }
    
    required convenience init?(coder: NSCoder) {
        let stackLimit = coder.decodeInteger(forKey: "stackLimit")
        guard let keyedDecoder = coder as? NSKeyedUnarchiver else {
            fatalError("Must use Keyed Coding")
        }
        
        let itemState = keyedDecoder.decodeDecodable(ItemState.self, forKey: "itemState") ?? .inForest
        let itemType = keyedDecoder.decodeDecodable(ItemType.self, forKey: "itemType") ?? .toy
        guard let name = coder.decodeObject(forKey: "name") as? String,
              let itemDescription = coder.decodeObject(forKey: "itemDescription") as? String,
              let modifier = coder.decodeObject(forKey: "modifier") as? String
       else { return nil }
        self.init(stackLimit:stackLimit,
                  name:name,
                  itemDescription: itemDescription,
                  itemState: itemState,
                  itemType: itemType,
                  modifier: modifier
                  )
   }
    
    func consumeItem() {
    }
    
    
}
