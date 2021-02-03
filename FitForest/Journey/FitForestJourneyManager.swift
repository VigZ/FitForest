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
        // Create, save, and associate the route with the provided workout.
//        builderPack.routeBuilder.finishRoute(with: myWorkout, metadata: myMetadata) { (newRoute, error) in
//
//            guard newRoute != nil else {
//                // Handle any errors here.
//                return
//            }
//
//            // Optional: Do something with the route here.
//        }
    }
    
    private func collectData(startDate: Date, endDate: Date){

        //TODO: Need to add error handling when using simulator and pedometer data unavailable.
        // Query StepTracker for step data during workout
//        stepCounter.queryPedometer(from: startDate, to: endDate) { (data, error) in
//
//            guard let data = data else {return}
            
            // Add data to JourneyWorkout
//            self.builderPack.journeyWorkout.end = endDate
//            self.builderPack.journeyWorkout.steps = Int(truncating: data.numberOfSteps)
//            self.builderPack.journeyWorkout.distance = data.distance as! Double
//            self.builderPack.journeyWorkout.averagePace = data.averageActivePace as! Float
            
            // Add data to workout.
            // Create Samples
            // data.startDate
            // data.endDate
            // data.steps
            // data.distance May want to use location objects for more accurate distance
            // data.currentPace
            // data.currentCadence
            // data.averageActivePace
            // data.floorsAscended / floorsDecended
//            self.workoutBuilder?.add([], completion: <#T##(Bool, Error?) -> Void#>)


//        }
    }

}

