//
//  NotificationCenter+names.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/25/21.
//

import Foundation

extension NSNotification.Name {
    //Pedometer update events
    
    class StepTrackerEvents {
        
        static let stepCountUpdated = NSNotification.Name(rawValue: "stepCountUpdated")
        
        static let distanceUpdated = NSNotification.Name(rawValue: "distanceUpdated")
        
        static let paceUpdated = NSNotification.Name(rawValue: "paceUpdated")
        
        static let floorsUpdated = NSNotification.Name(rawValue: "floorsUpdated")
    }
}
