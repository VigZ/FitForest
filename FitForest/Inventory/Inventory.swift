//
//  Inventory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/25/21.
//

import Foundation

class Inventory {
    
    static let sharedInstance = Inventory()
    
    var points: Int = 0 // Initial state should be retrieved from hard storage (via Save/Load module) TODO
    
    var itemHash = {}
    
    func addPoint() {
        self.points += 1
    }
}
