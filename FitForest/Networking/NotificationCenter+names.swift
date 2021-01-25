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
    }
}
