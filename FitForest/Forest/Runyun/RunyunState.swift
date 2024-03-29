//
//  RunyunState.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/26/21.
//

import Foundation

enum RunyunState: String, Codable {
    case idle
    case pickedUp
    case falling
    case interacting
    case walking
}
