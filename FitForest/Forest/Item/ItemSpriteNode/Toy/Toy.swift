//
//  Toy.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation

protocol Toy : PlayerInteractable, UnitInteractable, Placeable {
    // Toys are placeable, have collision, can be interacted with.(Player and ForestSprite)
    // PlayerInteractable has on tap and on hold effects
    // UnitInteractable means it has collision and Runyuns can interact with said object
    // Placeable means it can exist in the forest
}
