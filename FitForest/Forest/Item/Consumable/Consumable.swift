//
//  Consumable.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation

protocol Consumable: Item {
    // Consumables exist in the inventory, then when used, produce desired effect and delete themselves.
    func consumeItem()
}
