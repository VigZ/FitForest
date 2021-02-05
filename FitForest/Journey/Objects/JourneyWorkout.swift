//
//  Journey.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/1/21.
//

import Foundation

struct JourneyWorkout: CoreDataStructDecoder {
    
    static var entityType = "journey"
    
    
    var start: Date
    var end: Date?
    var distance: Double = 0
    var steps: Int = 0
    var averagePace: Float = 0.0
    var locations = [Location]()
    
    
    
    init(start: Date, end: Date?) {
        self.start = start
        self.end = end
    }
    
    var duration: TimeInterval? {
        return end?.timeIntervalSince(start) ?? nil
    }
    
    var totalEnergyBurned: Double {
        guard let duration = duration else { return 0}
        let caloriesPerHour: Double = 400 //Should make this a constant
        let hours: Double = duration / 3600
        let totalCalories = caloriesPerHour * hours
        return totalCalories
    }
}
