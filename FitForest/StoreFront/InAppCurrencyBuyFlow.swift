//
//  InAppCurrencyBuyFlow.swift
//  FitForest
//
//  Created by Kyle Vigorito on 8/30/21.
//

import Foundation
import CoreData

class InAppCurrencyBuyFlow: BuyFlow {
    
    var points: Int
    var inventory: InventoryManager
    
    init(points: Int, inventory: InventoryManager) {
        self.points = points
        self.inventory = inventory
    }
    
    func startBuy(item: StoreItem) throws {
        
        do {
           try validatePurchase(item)
        }
        
        catch BuyFlowErrors.notEnoughCurrency(let currency) {
            print("Does not have enough currency. Has \(currency)")
            sendFailNotification(error: BuyFlowErrors.notEnoughCurrency(currency: currency))
            return
        }
        
        catch BuyFlowErrors.notEnoughInventorySpace {
            print("Inventory item is at max stacks.")
            sendFailNotification(error: BuyFlowErrors.notEnoughInventorySpace)
            return
        }
        
        do {
            try commitPurchase(item)
        }
        
        catch BuyFlowErrors.couldNotCommitPurchase {
            print ("Could not commit purchase. Something went wrong.")
            sendFailNotification(error: BuyFlowErrors.couldNotCommitPurchase)
            return
        }
        
    }
    
    func validatePurchase(_ item: StoreItem) throws {
        // Check to see if user has enough gems.
        guard hasEnoughCurrency(item) else {
            throw BuyFlowErrors.notEnoughCurrency(currency: points)
        }
        
        guard hasInventorySpace(item, items: inventory.items) else {
            // Raise not enough inventory Space error. Etc. Etc.
            throw BuyFlowErrors.notEnoughInventorySpace
        }
        
    }
    
    func commitPurchase(_ item: StoreItem) throws {
        
        // Create Transaction object with: Date, previous gem count, post gem count, item name.
        
        do {
            try createTransaction(item)
        }
        catch {
            throw BuyFlowErrors.couldNotCreateTransaction
        }
        
        // Subtract currency based on Item Name.
        let newPoints = subtractPoints(points: points, storeItem: item)
        points = newPoints
        
        // Create Item and add to inventory.
        
        createItem(item)
        
        // Send out notification events for item added/bought.
        
        sendSuccessNotifications(item, remainingPoints: newPoints)
    }
    
    private func hasEnoughCurrency(_ item: StoreItem) -> Bool{
        guard points >= item.price else {
            return false
        }
        return true
    }
    
    private func hasInventorySpace(_ item: StoreItem, items: [Item]) -> Bool {
        // Loop through inventory, checking count of particular item.
        var count = 0
        for inventoryItem in items {
            if inventoryItem.name == item.name {
                count += 1
            }
            if count >= inventoryItem.stackLimit {
                return false
            }
        }
            return true
        }
    
    func createItem(_ item: StoreItem) {        
        //Should add some kind of error handling here.
        inventory.retrieveItemData(classIdentifier: item.classIdentifier, itemName: item.name)
    }
    
    func subtractPoints(points:Int, storeItem: StoreItem) -> Int {
        let newPoints = points - storeItem.price
        return newPoints
    }
    
    func createTransaction(_ item: StoreItem) throws {
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
            throw CoreDataError.didNotSave
            
        }
        
        print("Saved Transaction:\(String(describing: transaction.date)), \(String(describing: transaction.itemName))")
    }
    
    func sendSuccessNotifications(_ item: StoreItem, remainingPoints: Int) {
        NotificationCenter.default.post(name: Notification.Name.StoreEvents.itemPurchased, object: (item, remainingPoints))
        print("Item was purchased successfully")
    }
    
    func sendFailNotification(error: Error) {
        NotificationCenter.default.post(name: Notification.Name.StoreEvents.itemNotPurchased, object: error)
        print("Item could not be purchased successfully")
    }
    
    }
