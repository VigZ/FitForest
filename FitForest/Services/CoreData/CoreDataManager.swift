//
//  CoreDataManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import Foundation
import CoreData

class CoreDataManager: CoreDataCRUD {
    
    
    static let sharedInstance = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FitForest")
        container.loadPersistentStores { (_, error) in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        return container
        }()

    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    var backgroundContext: NSManagedObjectContext { return persistentContainer.newBackgroundContext() }

    
  
//  class func saveContext () {
//    let context = persistentContainer.viewContext
//    
//    guard context.hasChanges else {
//      return
//    }
//    
//    do {
//      try context.save()
//    } catch {
//      let nserror = error as NSError
//      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//    }
//  }
    
    func create<T>(type: T.Type, managedObjectContext: NSManagedObjectContext, completion: @escaping ((T) -> Void)) {
        <#code#>
    }
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, relationshipKeysToFetch: [String]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([T]?) -> Void)) {
        
        managedObjectContext.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
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
                completion(result as? [T])
            } catch {
                completion(nil)
            }
        }
    }
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([T]?) -> Void)) {
        <#code#>
    }
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, managedObjectContext: NSManagedObjectContext, completion: @escaping (([T]?) -> Void)) {
        <#code#>
    }
    
    func fetchCount<T>(type: T.Type, predicate: NSPredicate, managedObjectContext: NSManagedObjectContext, completion: @escaping ((Int) -> Void)) {
        <#code#>
    }
}
