//
//  CoreDataManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import Foundation
import CoreData

class CoreDataManager {
  
  static let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "FitForest")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  static var context: NSManagedObjectContext { return persistentContainer.viewContext }
  
  class func saveContext () {
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
