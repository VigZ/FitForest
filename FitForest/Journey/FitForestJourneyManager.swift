//
//  FitForestJourneyManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/2/21.
//

import Foundation
import HealthKit
import CoreLocation

class FitForestJourneyManager: NSObject {
    
    var builderPack: BuilderPack!
    
    //External Services
    let locationManager = FitForestLocationManager.sharedInstance
    let stepCounter = StepTracker.sharedInstance
    let fitForestHealthStore = FitForestHealthStore.sharedInstance
    let coreDataStack = CoreDataStack.sharedInstance
    
    
    
    init(journeyWorkout:JourneyWorkout) {
       // Create Builder Pack
        guard let hkHealthStore = fitForestHealthStore.hkHealthStore else {
            //Handle Error here
            return }
        
        let workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: hkHealthStore, device: nil)
        
        self.builderPack = BuilderPack(journeyWorkout:journeyWorkout, routeBuilder: workoutRouteBuilder)
    }
    
    func createWorkout(){
        
        let endDate = Date()
        
        let startDate = builderPack.journeyWorkout.startDate
        
        // Create workout with data
        collectData(startDate: startDate, endDate: endDate)
        

    }
    
    private func collectData(startDate: Date, endDate: Date){

        //TODO: Need to add error handling when using simulator and pedometer data unavailable.
        
        // Query StepTracker for step data during workout
        stepCounter.queryPedometer(from: startDate, to: endDate) { [unowned self] (data, error) in

            guard let data = data else {return}
            
            // Add data to JourneyWorkout
            self.builderPack.journeyWorkout.endDate = endDate
            self.builderPack.journeyWorkout.steps = Int(truncating: data.numberOfSteps)
            self.builderPack.journeyWorkout.distance = data.distance?.doubleValue ?? 0
            self.builderPack.journeyWorkout.averagePace = data.averageActivePace?.floatValue ?? 0.0
            
            // Add Calorie Sample
            let caloriesBurned = self.builderPack.journeyWorkout.totalEnergyBurned
            let calorieQuantity = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: caloriesBurned)
            let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
            let calorieSample = HKQuantitySample(type: calorieType!, quantity: calorieQuantity, start: startDate, end: endDate)
            
            // Add Distance Sample
            let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: self.builderPack.journeyWorkout.distance)
            let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
            let distanceSample = HKQuantitySample(type: distanceType!, quantity: distanceQuantity, start: startDate, end: endDate)
            
            // Add Step Sample
            let stepQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(self.builderPack.journeyWorkout.steps))
            let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)
            let stepSample = HKQuantitySample(type: stepType!, quantity: stepQuantity, start: startDate, end: endDate)
            
            // Create Workout
            let duration = endDate.timeIntervalSince(startDate)
            let newWorkout = HKWorkout(activityType: .running, start: startDate, end: endDate, duration: duration, totalEnergyBurned: calorieQuantity, totalDistance: distanceQuantity, metadata: nil)
            
            fitForestHealthStore.hkHealthStore?.save(newWorkout) { (success, error) in
                
                guard success else {
                    //Handle error
                    return
                }
                
                // Create Samples
                self.fitForestHealthStore.hkHealthStore?.add([stepSample, distanceSample, calorieSample], to: newWorkout){  (success, error) in
                }
                
                self.builderPack.routeBuilder.finishRoute(with: newWorkout, metadata: nil) { (newRoute, error) in
                            guard newRoute != nil else {
                                // Handle any errors here.
                                return
                            }
                    //TODO: THERE MAY BE A CONCURRENCY ISSUE. PLEASE FIX FUTURE KYLE.
                            // Optional: Do something with the route here.
                        }
                do {
                    let journeyEntity = try builderPack.journeyWorkout.toCoreData(context: coreDataStack.context)
                    print(journeyEntity)
                    let locationsSet = journeyEntity.mutableSetValue(forKey: "locations")
                    for location in builderPack.journeyWorkout.locations {
                        locationsSet.add(location)
                    }
                    self.coreDataStack.saveContext()
                    
                }
                
                catch {
                    
                    // Add error handling here
                
                }
                
            }

            }
            // Create, save, and associate the route with the provided workout.

    }
    
     func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
}

