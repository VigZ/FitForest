//
//  CoreDataDecodeable.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/5/21.
//

import Foundation
import CoreData

protocol CoreDataDecodeable {
    
    static var entityName: String { get } // The entity type that will be created from struct.
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject
    
    
}

extension CoreDataDecodeable {
    
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject {
        
        let entityName = type(of:self).entityName
        
        // Create the Entity Description
        guard let description = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        else { throw SerializationError.unknownEntity(name: entityName) }
        
        // TODO: Fix error handling here.
        // Create the NSManagedObject
        let managedObject = NSManagedObject(entity: description, insertInto: context)
        
        // Create a Mirror
        let mirror = Mirror(reflecting: self)

        // Make sure we're analyzing a struct
        
        guard mirror.displayStyle == .`struct` else { throw SerializationError.structRequired }

        for case let (label?, anyValue) in mirror.children {
            // TODO: Add error handling for when keys don't match exactly.
            
            if label == "ranking" {
                let rank = anyValue as? Ranking
                managedObject.setValue(rank?.rawValue, forKey: label)
            }
            else if label == "attatchedJourney" {
                continue
            }
            
            else {
                managedObject.setValue(anyValue, forKey: label)
            }
            
        }
        
        // TODO: Add error here to make sure that object keys on struct match core data representation.
        return managedObject
    }
}

