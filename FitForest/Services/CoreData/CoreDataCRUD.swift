//
//  CoreDataCRUD.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import Foundation
import CoreData

protocol CoreDataCRUD {
    
    func create<T>(type: T.Type, managedObjectContext: NSManagedObjectContext, completion: @escaping ((T) -> Void))
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, relationshipKeysToFetch: [String]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([T]?) -> Void))
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([T]?) -> Void))
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([T]?) -> Void))
    
    func fetchCount<T>(type: T.Type, predicate: NSPredicate, managedObjectContext: NSManagedObjectContext, completion: @escaping ((Int) -> Void))
}
