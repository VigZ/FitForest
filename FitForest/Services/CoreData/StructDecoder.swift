//
//  StructDecoder.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/5/21.
//

import Foundation
import CoreData

protocol CoreDataStructDecoder {
    
    static var entityType: String { get }
    
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject
}

extension CoreDataStructDecoder {
    
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject {
        
        let entityName = type(of: self).entityType
        
        guard let description =
                NSEntityDescription.entity(forEntityName: entityName, in: CoreDataManager.sharedInstance.context)
        else {
            throw SerializationError.unknownEntity(name: entityName)
        }
        
        
    }
}
