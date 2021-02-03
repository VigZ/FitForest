//
//  FitForestJourneyManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/2/21.
//

import Foundation
import HealthKit
import CoreLocation

class FitForestJourneyManager {
    
    var builderPack: BuilderPack!
    
    
    //External Services
    let locationManager = LocationManager.sharedInstance
    let stepCounter = StepTracker.sharedInstance
    let fitForestHealthStore = FitForestHealthStore.sharedInstance
//    let coreDataManager = CoreDataManager.sharedInstance
    
    
    
    init(journeyWorkout:JourneyWorkout) {
       // Create Builder Pack
        guard let hkHealthStore = fitForestHealthStore.hkHealthStore else {
            //Handle Error here
            return }
        let workoutBuilder = HKWorkoutBuilder(healthStore: hkHealthStore, configuration: fitForestHealthStore.hkWorkoutConfig, device: nil)
        
        let workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: hkHealthStore, device: nil)
        
        self.builderPack = BuilderPack(journeyWorkout:journeyWorkout, workoutBuilder: workoutBuilder, routeBuilder: workoutRouteBuilder)
    }
    
    func requestUserPermissions(){
        //Check Location Data
        requestLocationData()
        
        //Request Health Permissions
        requestHealthKitPermissions()
    
    }
    
    private func requestLocationData() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func requestHealthKitPermissions(){
        fitForestHealthStore.requestUserPermissions()
    }
    
    func startWorkout() {
        builderPack.workoutBuilder.beginCollection(withStart: builderPack.journeyWorkout.start){
            (sucess, error) in
            guard !sucess else {
                //Handle error here
                return
            }
        }
    }
    
    func endWorkout(){
        
        let endDate = Date()
        
        guard let startDate = builderPack.workoutBuilder.startDate else {return}
        
        collectData(startDate: startDate, endDate: endDate)
        builderPack.workoutBuilder.endCollection(withEnd: endDate){
            (sucess, error) in
            guard !sucess else {
                
                return
                // handle error
            }
        }
        builderPack.workoutBuilder.finishWorkout(){
            (workout, error) in
            guard let workout = workout else {
                //Throw error here.
                return
            }
                // Create, save, and associate the route with the provided workout.
            self.builderPack.routeBuilder.finishRoute(with: workout, metadata: nil) { (newRoute, error) in

                        guard newRoute != nil else {
                            // Handle any errors here.
                            return
                        }

                        // Optional: Do something with the route here.
                    }
            
        }

    }
    
    private func collectData(startDate: Date, endDate: Date){

        //TODO: Need to add error handling when using simulator and pedometer data unavailable.
        // Query StepTracker for step data during workout
        stepCounter.queryPedometer(from: startDate, to: endDate) { (data, error) in

            guard let data = data else {return}
            
            // Add data to JourneyWorkout
            self.builderPack.journeyWorkout.end = endDate
            self.builderPack.journeyWorkout.steps = Int(truncating: data.numberOfSteps)
            self.builderPack.journeyWorkout.distance = data.distance?.doubleValue ?? 0
            self.builderPack.journeyWorkout.averagePace = data.averageActivePace?.floatValue ?? 0.0
            
            
            
            // Add data to workout.
            
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
            
            
//             Create Samples
//             data.startDate
//             data.endDate
//             data.steps
//             data.distance May want to use location objects for more accurate distance
//             data.averageActivePace
//             data.floorsAscended
            
            self.builderPack.workoutBuilder.add([stepSample, distanceSample, calorieSample]){  (success, error) in
                print(success)
            }


        }
    }

}

