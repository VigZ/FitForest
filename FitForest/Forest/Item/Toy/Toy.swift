//
//  Toy.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation

protocol Toy : Item, PlayerInteractable, UnitInteractable, Placeable {
    // Toys are placeable, have collision, can be interacted with.(Player and ForestSprite)
}
