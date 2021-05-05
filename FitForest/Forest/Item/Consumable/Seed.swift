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
    var modifier: SeedModifier = .basic
    var seedType: SeedType = .red
    
    init(stackLimit:Int ,name: String, itemDescription: String, itemState: ItemState, itemType: ItemType, modifier: SeedModifier, seedType: SeedType) {
        self.stackLimit = stackLimit
        self.name = name
        self.itemDescription = itemDescription
        self.itemState = itemState
        self.itemType = itemType
        self.modifier = modifier
        self.seedType = seedType
    }
    
    func encode(with coder: NSCoder) {
        guard let keyedCoder = coder as? NSKeyedArchiver else {
                    fatalError("Must use Keyed Coding")
                }
        coder.encode(self.stackLimit, forKey: "stackLimit")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.itemDescription, forKey: "itemDescription")
        try! keyedCoder.encodeEncodable(self.itemState, forKey: "itemState")
        try! keyedCoder.encodeEncodable(self.itemType, forKey: "itemType")
        try! keyedCoder.encodeEncodable(self.seedType, forKey: "seedType")
        try! keyedCoder.encodeEncodable(self.seedType, forKey: "modifier")
    }
    
    required convenience init?(coder: NSCoder) {
        let stackLimit = coder.decodeInteger(forKey: "stackLimit")
        guard let keyedDecoder = coder as? NSKeyedUnarchiver else {
            fatalError("Must use Keyed Coding")
        }
        
        let itemState = keyedDecoder.decodeDecodable(ItemState.self, forKey: "itemState") ?? .inForest
        let itemType = keyedDecoder.decodeDecodable(ItemType.self, forKey: "itemType") ?? .toy
        let seedType = keyedDecoder.decodeDecodable(SeedType.self, forKey: "seedType") ?? .red
        let seedModifier = keyedDecoder.decodeDecodable(SeedModifier.self, forKey: "modifier") ?? .basic
        guard let name = coder.decodeObject(forKey: "name") as? String,
              let itemDescription = coder.decodeObject(forKey: "itemDescription") as? String
       else { return nil }
        self.init(stackLimit:stackLimit,
                  name:name,
                  itemDescription: itemDescription,
                  itemState: itemState,
                  itemType: itemType,
                  modifier: seedModifier,
                  seedType: seedType
                  )
   }
    
    func consumeItem() {
    }
    
    
}
