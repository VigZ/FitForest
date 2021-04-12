//
//  Item.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/12/21.
//

import Foundation

protocol Item {
    var stackLimit: Int { get set }
    var name: String { get set }
    var itemType: ItemType { get set }
}

