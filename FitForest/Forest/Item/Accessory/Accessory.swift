//
//  Accessory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation
import SpriteKit

class Accessory:NSObject, NSCoding, Item {
    
    var stackLimit:Int = 3
    var name: String
    var itemDescription: String = ""
    var itemState: ItemState = .inInventory
    var itemType: ItemType = .accessory
    var anchorPoint: CGPoint
    var runyunAnchorPoint: CGPoint
    
    init(stackLimit:Int ,name: String, itemDescription: String, itemState: ItemState, itemType: ItemType, anchorPoint: CGPoint, runyunAnchorPoint: CGPoint) {
        self.stackLimit = stackLimit
        self.name = name
        self.itemDescription = itemDescription
        self.itemState = itemState
        self.itemType = itemType
        self.anchorPoint = anchorPoint
        self.runyunAnchorPoint = runyunAnchorPoint
        
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
        coder.encode(self.anchorPoint, forKey: "anchorPoint")
        coder.encode(self.runyunAnchorPoint, forKey: "runyunAnchorPoint")
        
    }
    
    required convenience init?(coder: NSCoder) {
        let stackLimit = coder.decodeInteger(forKey: "stackLimit")
        let anchorPoint = coder.decodeCGPoint(forKey: "anchorPoint")
        let runyunAnchorPoint = coder.decodeCGPoint(forKey: "runyunAnchorPoint")
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
                  itemType: itemType,
                  anchorPoint: anchorPoint,
                  runyunAnchorPoint: runyunAnchorPoint
                  )
   }
}
