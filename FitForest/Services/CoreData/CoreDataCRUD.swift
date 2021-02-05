//
//  CoreDataCRUD.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import Foundation
import CoreData

protocol CoreDataCRUD {
    
    associatedtype EntityType
    
    
    static func create( managedObjectContext: NSManagedObjectContext, completion: @escaping ((EntityType) -> Void))
    
    static func fetch( predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, relationshipKeysToFetch: [String]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([EntityType]?) -> Void))
    
    static func fetch( predicate: NSPredicate?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([EntityType]?) -> Void))
    
    static func fetch ( predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([EntityType]?) -> Void))
    
    static func fetchCount( predicate: NSPredicate, managedObjectContext: NSManagedObjectContext, completion: @escaping ((Int) -> Void))
}

extension CoreDataCRUD {
    
    static func create(managedObjectContext: NSManagedObjectContext, completion: @escaping ((EntityType) -> Void)) {
        
        let entityDescription =  NSEntityDescription.entity(forEntityName: String.init(describing: EntityType.self),
                                                            in: managedObjectContext)
        let entity = NSManagedObject(entity: entityDescription!,
                                     insertInto: managedObjectContext)
        completion(entity as! Self.EntityType)
        
    }
    
    static func fetch( predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, relationshipKeysToFetch: [String]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([EntityType]?) -> Void)){
        
        managedObjectContext.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: EntityType.self))
            if let predicate = predicate {
                request.predicate = predicate
            }
            if let sortDescriptors = sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }
            if let relationshipKeysToFetch = relationshipKeysToFetch {
                request.relationshipKeyPathsForPrefetching = relationshipKeysToFetch
            }
            do {
                let result = try managedObjectContext.fetch(request)
                completion(result as? [EntityType])
            } catch {
                completion(nil)
            }
        }
        
    }
    
    static func fetch( predicate: NSPredicate?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([EntityType]?) -> Void)){
        
    }
    
    static func fetch( predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([EntityType]?) -> Void)){
        
    }
    
    static func fetchCount( predicate: NSPredicate, managedObjectContext: NSManagedObjectContext, completion: @escaping ((Int) -> Void)) {
        
    }
}
