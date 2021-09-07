//
//  InventoryManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation

class InventoryManager:NSObject, NSCoding {
    typealias ItemDictionary = [String: [[String:Any]]]
    
    var items = [Item]()
    var runyunStorage = [RunyunStorageObject]()
    
    func encode(with coder: NSCoder) {
        coder.encode(self.items, forKey: "items")
        coder.encode(self.runyunStorage, forKey: "runyunStorage")
    }
    
    init(items:[Item], runyunStorage: [RunyunStorageObject]) {
        self.items = items
        self.runyunStorage = runyunStorage
    }
    
    required convenience init?(coder: NSCoder) {
       guard let items = coder.decodeObject(forKey: "items") as? [Item],
             let runyunStorage = coder.decodeObject(forKey: "runyunStorage") as? [RunyunStorageObject]
       else { return nil }
       print("Unpacking saved inventory...")
        self.init(items:items, runyunStorage: runyunStorage)
   }
    
    func retrieveItemData(classIdentifier: String, itemName: String) {
        
        do {
            if let file = Bundle.main.url(forResource: "ItemDictionary", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? ItemDictionary {
                    // json is a dictionary
                    // Parse Json file for correct item data
                    
                    guard let itemClassArray = object[classIdentifier] else {return}
                    guard let item = itemClassArray.first(where:{ $0["name"] as! String == itemName }) else {
                        return
                        // Should add error handling here to handle when an item can't be created.
                    }
                    guard let createdItem = ItemFactory.sharedInstance.createItem(itemClass: classIdentifier, data: item) else {return}
                    //TODO ADD ERROR HANDLING FOR ALL OF THE GUARD STATEMENTS
                    
                    print(object)
                    self.addItem(item: createdItem)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("The file does not exist.")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
     func addItem(item:Item){
        // Add item to item array
        self.items.append(item)
        // Save GameData
        GameData.sharedInstance.saveToDisk()
        let ns = NotificationCenter.default
        ns.post(name: Notification.Name.ForestEvents.itemAdded, object: item)
        print(item)
        
        //TODO Add push notification for item recieved and hilight to newly added item in inventory.
    }

    func removeItem(item:Item) -> Bool {
        items.removeAll(where: { $0 === item})
        GameData.sharedInstance.saveToDisk()
        return true
        // Attempt to remove item from array if it exists.
        // Delete any attached spriteNodes
        // Return true if successful, false if not
    }
    
    func addRunyun(runyun:RunyunStorageObject){
       // Add item to item array
       self.runyunStorage.append(runyun)
       // Save GameData
       GameData.sharedInstance.saveToDisk()
       print(runyun)
       
       //TODO Add push notification for item recieved and hilight to newly added item in inventory.
   }
    
    func removeRunyun(runyun:RunyunStorageObject) -> Bool {
        items.removeAll(where: { $0 === runyun})
        GameData.sharedInstance.saveToDisk()
        return true
    }

}
    
    

