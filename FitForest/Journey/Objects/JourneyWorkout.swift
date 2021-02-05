//
//  Journey.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/1/21.
//

import Foundation

struct JourneyWorkout: CoreDataDecodeable {
    
    static var entityName = "Journey"
    
    var startDate: Date
    var endDate: Date?
    var distance: Double = 0
    var steps: Int = 0
    var averagePace: Float = 0.0
    var locations = [Location]()
    
    
    
    init(start: Date, end: Date?) {
        self.startDate = start
        self.endDate = end
    }
    
    var duration: TimeInterval? {
        return endDate?.timeIntervalSince(startDate) ?? nil
    }
    
    var totalEnergyBurned: Double {
        guard let duration = duration else { return 0}
        let caloriesPerHour: Double = 400 //Should make this a constant
        let hours: Double = duration / 3600
        let totalCalories = caloriesPerHour * hours
        return totalCalories
    }
}
