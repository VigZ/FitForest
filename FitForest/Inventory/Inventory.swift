//
//  Inventory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/25/21.
//

import Foundation

class Inventory {
    
    static let sharedInstance = Inventory()
    
    var points: Int {
        return StepTracker.sharedInstance.numberOfSteps
    }
    
    var itemHash = {}    
}
