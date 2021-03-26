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
    var locations = Set<Location>()
    var ranking: Ranking = Ranking.bronze
    
    var attachedJourney: Journey!
    
    
    
    init(start: Date, end: Date?) {
        self.startDate = start
        self.endDate = end
    }
    
    init(journey: Journey) {
        self.startDate = journey.startDate!
        self.endDate = journey.endDate
        self.distance = journey.distance
        self.steps = Int(journey.steps)
        self.averagePace = journey.averagePace
        self.ranking = Ranking(rawValue: Int(journey.ranking)) ?? Ranking.bronze
        if journey.locations != nil{
            self.locations = journey.locations as! Set<Location>
        }
        self.attachedJourney = journey
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
