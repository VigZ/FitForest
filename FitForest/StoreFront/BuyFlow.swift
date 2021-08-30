//
//  BuyFlow.swift
//  FitForest
//
//  Created by Kyle Vigorito on 8/30/21.
//

import Foundation

protocol BuyFlow {
    
    func startBuy(item: StoreItem)
    
    func validatePurchase(_ item: StoreItem)
    
    func commitPurchase(_ item: StoreItem)
}
