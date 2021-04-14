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
        do {
            if let file = Bundle.main.url(forResource: "ItemDictionary", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("The file does not exist.")
            }
        } catch {
            print(error.localizedDescription)
        }
        // Parse Json file for correct item data
        // Call addItem
    }
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "points", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
    
    
//    func addItem(data:Data) -> Item{
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
    
    

