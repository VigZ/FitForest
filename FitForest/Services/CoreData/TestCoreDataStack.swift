//
//  TestCoreDataStack.swift
//  FitForest
//
//  Created by Kyle Vigorito on 9/6/21.
//

import Foundation
import CoreData

class TestCoreDataStack {
    
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "FitForestTest")

      let description = NSPersistentStoreDescription()
      description.url = URL(fileURLWithPath: "/dev/null")
      container.persistentStoreDescriptions = [description]

      container.loadPersistentStores(completionHandler: { _, error in
        if let error = error as NSError? {
          fatalError("Failed to load stores: \(error), \(error.userInfo)")
        }
      })

      return container
    }()
}
