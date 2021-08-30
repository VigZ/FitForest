//
//  BuyFlow.swift
//  FitForest
//
//  Created by Kyle Vigorito on 8/30/21.
//

import Foundation

protocol BuyFlow {
    
    func startBuy()
    
    func validatePurchase()
    
    func commitPurchase()
}
