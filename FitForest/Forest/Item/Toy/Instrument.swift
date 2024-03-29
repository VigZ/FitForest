//
//  Instrument.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/14/21.
//

import Foundation

class Instrument: NSObject, NSCoding , Item {
    
    var stackLimit:Int = 3
    var name: String
    var itemDescription: String = ""
    var itemState: ItemState = .inInventory
    var itemType: ItemType = .toy
    
    init(stackLimit:Int ,name: String, itemDescription: String, itemState: ItemState, itemType: ItemType) {
        self.stackLimit = stackLimit
        self.name = name
        self.itemDescription = itemDescription
        self.itemState = itemState
        self.itemType = itemType
        
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
        
    }
    
    required convenience init?(coder: NSCoder) {
        let stackLimit = coder.decodeInteger(forKey: "stackLimit")
        guard let keyedDecoder = coder as? NSKeyedUnarchiver else {
            fatalError("Must use Keyed Coding")
        }
        
        let itemState = keyedDecoder.decodeDecodable(ItemState.self, forKey: "itemState") ?? .inForest
        let itemType = keyedDecoder.decodeDecodable(ItemType.self, forKey: "itemType") ?? .toy
        guard let name = coder.decodeObject(forKey: "name") as? String,
              let itemDescription = coder.decodeObject(forKey: "itemDescription") as? String
       else { return nil }
        self.init(stackLimit:stackLimit,
                  name:name,
                  itemDescription: itemDescription,
                  itemState: itemState,
                  itemType: itemType
                  )
   }
}
