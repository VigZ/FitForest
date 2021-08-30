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
        <#code#>
    }
    
    func commitPurchase(_ item: StoreItem) {
        <#code#>
    }
    
    
}
