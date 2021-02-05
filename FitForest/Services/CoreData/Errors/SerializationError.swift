//
//  SerializationError.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/5/21.
//

import Foundation

enum SerializationError: Error {
    
    // Only structs are supported
    
    case structRequired
    
    // The entity does not exist in the Core Data Model
    
    case unknownEntity(name: String)
    
    // The provided type cannot be stored in Core Data
    
    case unsupportedSubType(label: String?)
}
