//
//  Item.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/13/21.
//

import Foundation

protocol Item: AnyObject {
    
    var stackLimit:Int { get set }
    var name: String { get set }
    var itemDescription: String { get set }
    var itemState: ItemState { get set }

}


