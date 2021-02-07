//
//  CoreDataManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
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

    
  
  func saveContext () {
    let context = persistentContainer.viewContext

    guard context.hasChanges else {
      return
    }

    do {
      try context.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
