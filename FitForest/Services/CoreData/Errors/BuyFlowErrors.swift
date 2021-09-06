//
//  BuyFlowErrors.swift
//  FitForest
//
//  Created by Kyle Vigorito on 9/6/21.
//

import Foundation


enum BuyFlowErrors: Error {
    
    case notEnoughCurrency(currency:Int)
    
    case notEnoughInventorySpace
}
