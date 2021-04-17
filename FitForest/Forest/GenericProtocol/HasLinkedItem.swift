//
//  LinkedItem.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/17/21.
//

import Foundation

protocol HasLinkedItem {
    
    var linkedInventoryItem: Item! { get set }
    
    func toggleLinkedItem()
}
