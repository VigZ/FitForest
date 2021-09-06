//
//  InAppCurrencyBuyFlow.swift
//  FitForest
//
//  Created by Kyle Vigorito on 8/30/21.
//

import Foundation
import CoreData

class InAppCurrencyBuyFlow: BuyFlow {
    
    func startBuy(item: StoreItem) {
        validatePurchase(item)
        commitPurchase(item)
    }
    
    func validatePurchase(_ item: StoreItem) {
        // Check to see if user has enough gems.
        guard hasEnoughCurrency(item) else {
            // Raise not enough currency error. Etc. Etc.
            return
        }
        
        guard hasInventorySpace(item) else {
            // Raise not enough inventory Space error. Etc. Etc.
            return
        }
        
        commitPurchase(item)
        
    }
    
    func commitPurchase(_ item: StoreItem) {
        
        // Create Transaction object with: Date, previous gem count, post gem count, item name.
        
        createTransaction(item)
        
        // Subtract currency based on Item Name.
        
        var points = GameData.sharedInstance.points
        points -= item.price
        
        // Create Item and add to inventory.
        
        createItem(item)
        
        // Send out notification events for item added/bought.
        
        sendNotifications(item)
    }
    
    private func hasEnoughCurrency(_ item: StoreItem) -> Bool{
        let points = GameData.sharedInstance.points
        guard points >= item.price else {
            return false
        }
        return true
    }
    
    private func hasInventorySpace(_ item: StoreItem) -> Bool {
        let items = GameData.sharedInstance.inventory.items
        // Loop through inventory, checking count of particular item.
        var count = 0
        
        for inventoryItem in items {
            guard count < inventoryItem.stackLimit else {
                return false
            }
            if inventoryItem.name == item.name {
                count += 1
            }
        }
            return true
        }
    
    func createItem(_ item: StoreItem) {
        let inventory = GameData.sharedInstance.inventory
        
        //Should add some kind of error handling here.
        inventory?.retrieveItemData(classIdentifier: item.classIdentifier, itemName: item.name)
    }
    
    func createTransaction(_ item: StoreItem) {
        // Create new Transaction record for item
        let context = CoreDataStack.sharedInstance.context
        let points = GameData.sharedInstance.points
        let transaction = StoreTransaction(context: context)

        // Assign values to the entity's properties
        transaction.date = Date()
        transaction.itemName = item.name
        transaction.prePurchaseCount = Int64(points)
        transaction.postPurchaseCount = Int64(points - item.price)

        // To save the new entity to the persistent store, call
        // save on the context
        do {
            try context.save()
        }
        catch {
            // Handle Error
            print("Something went wrong.")
        }
        
        print("Saved Transaction:\(String(describing: transaction.date)), \(String(describing: transaction.itemName))")
    }
    
    func sendNotifications(_ item: StoreItem) {
        NotificationCenter.default.post(name: Notification.Name.StoreEvents.itemPurchased, object: item)
        print("Item was purchased successfully")
    }
    
    }
