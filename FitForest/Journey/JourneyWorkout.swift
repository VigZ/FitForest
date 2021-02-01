//
//  Journey.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/1/21.
//

import Foundation

struct JourneyWorkout {
    
    var start: Date
    var end: Date
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
    
    var totalEnergyBurned: Double {
        let caloriesPerHour: Double = 400 //Should make this a constant
        let hours: Double = duration / 3600
        let totalCalories = caloriesPerHour * hours
        return totalCalories
    }
}
