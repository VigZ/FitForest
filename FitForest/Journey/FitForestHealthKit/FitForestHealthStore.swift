//
//  FitForestHealthStore.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/1/21.
//

import Foundation
import HealthKit

class FitForestHealthStore {
    
    static let sharedInstance = FitForestHealthStore()
    
    var hkHealthStore: HKHealthStore? = {
        //check if health store is available
        if HKHealthStore.isHealthDataAvailable(){
            return HKHealthStore()
        }
        return nil
    }()
    
    var hkWorkoutConfig: HKWorkoutConfiguration = {
        let config = HKWorkoutConfiguration()
        config.activityType = .running
        return config
    }()
    
    private var stepTracker = StepTracker.sharedInstance
    
    var workoutBuilder: HKWorkoutBuilder?
    
    func requestUserPermissions(){
        let permissions = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        hkHealthStore?.requestAuthorization(toShare: permissions, read: permissions) { (sucess, error) in
            if !sucess {
                // TODO: Add error handling for failure.
            }
        }
    }
    
    func createWorkout(){
        guard let hkHealthStore = hkHealthStore else { return }
        workoutBuilder = HKWorkoutBuilder(healthStore: hkHealthStore, configuration: hkWorkoutConfig, device: nil)
        startWorkout()
    }
        
    private func startWorkout() {
        workoutBuilder?.beginCollection(withStart: Date()){
            (bool, error) in
            }
        
        }
    
    func endWorkout(){
        let endDate = Date()
        self.collectData(endDate: endDate)
        workoutBuilder?.endCollection(withEnd: endDate){
            (bool, error) in
        }
    }
    
    private func collectData(endDate: Date){
        
        guard let start = workoutBuilder?.startDate else {
            return
        }
        //TODO: Need to add error handling when using simulator and pedometer data unavailable.
        // Query StepTracker for step data during workout
        stepTracker.queryPedometer(from: start, to: endDate) { (data, error) in
            
            guard let data = data else {return}
            
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

            
        }
    }
    
    func collectDistance(){
        
    }
    
    func collectEnergyBurned(){
        
    }
    
    func isActiveWorkoutBuilder() -> Bool {
        return workoutBuilder != nil ? true : false
    }
}
