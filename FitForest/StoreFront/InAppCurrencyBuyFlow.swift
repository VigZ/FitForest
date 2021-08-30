//
//  InAppCurrencyBuyFlow.swift
//  FitForest
//
//  Created by Kyle Vigorito on 8/30/21.
//

import Foundation

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
        
        
        // Check to see if user has max of item in inventory.
        
        
    }
    
    func commitPurchase(_ item: StoreItem) {
        <#code#>
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
    }
