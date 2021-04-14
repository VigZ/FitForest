//
//  Placeable.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation
import SpriteKit

protocol Placeable: SKSpriteNode {
    var isBeingMoved: Bool {get set}
    func pickedUp()
    // Can be long tapped to picked up and moved.
}
