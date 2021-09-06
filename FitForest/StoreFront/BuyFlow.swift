//
//  BuyFlow.swift
//  FitForest
//
//  Created by Kyle Vigorito on 8/30/21.
//

import Foundation

protocol BuyFlow {
    
    func startBuy(item: StoreItem) throws
    
    func validatePurchase(_ item: StoreItem) throws
    
    func commitPurchase(_ item: StoreItem) throws
}
