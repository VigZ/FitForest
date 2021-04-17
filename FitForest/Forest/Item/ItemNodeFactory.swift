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
        let underScored_name = item.name.replacingOccurrences(of: " ", with: "_")
            switch item {
                case is Ball:
                    let newNode = BallNode(name:underScored_name)
                    newNode.linkedInventoryItem = item as? Ball
                    return newNode
                case is Instrument:
                    let newNode = InstrumentNode(name:underScored_name)
                    newNode.linkedInventoryItem = item as? Instrument
                    return newNode
            default:
                return nil
            }
        }
}
