//
//  ItemState.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation

enum ItemState:String, Codable{
    case inInventory
    case inForest
    
    mutating func toggle() {
        switch self {
        case .inInventory:
            self = .inForest
        case .inForest:
            self = .inInventory
        }
    }
}
