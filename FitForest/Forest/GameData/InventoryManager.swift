//
//  InventoryManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation

class InventoryManager:NSObject, NSCoding {
    
    var items = [Item]()
    
    func encode(with coder: NSCoder) {
        coder.encode(self.items, forKey: "items")
    }
    
    init(items:[Item]) {
        self.items = items
    }
    
    required convenience init?(coder: NSCoder) {
       guard let items = coder.decodeObject(forKey: "items") as? [Item]
       else { return nil }
       print("Unpacking saved inventory...")
        self.init(items:items)
   }
    
    func retrieveItemData(identifier: String) {
        // Parse Json file for correct item data
        // Call addItem
    }
}
    
    
//    func addItem(json:Data) -> Item{
//        // Use factory object to create and return correct item
//        // Add item to item array
//        
//    }
//    
//    func removeItem(item:Item) -> Bool {
//        // Attempt to remove item from array if it exists.
//        // Delete any attached spriteNodes
//        // Return true if successful, false if not
//    }
    
    

