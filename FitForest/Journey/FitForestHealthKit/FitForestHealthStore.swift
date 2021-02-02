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
    
    private var hkHealthStore: HKHealthStore? = {
        //check if health store is available
        if HKHealthStore.isHealthDataAvailable(){
            return HKHealthStore()
        }
        return nil
    }()
    
    private var hkWorkoutConfig: HKWorkoutConfiguration = {
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
    }
        
    func startWorkout() {
        workoutBuilder?.beginCollection(withStart: Date()){
            (bool, error) in
            }
        
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//
//            builder.finishWorkout(){ (workout, error) in
//
//            }
//        }
    
    func endWorkout(){
        let endDate = Date()
        self.collectSteps(endDate: endDate)
        workoutBuilder?.endCollection(withEnd: endDate){
            (bool, error) in
        }
    }
    
    func collectSteps(endDate: Date){
        
        guard let start = workoutBuilder?.startDate else {
            return
        }
        // Query StepTracker for step data during workout
        stepTracker.queryPedometer(from: start, to: endDate) { (data, error) in
            
            guard let data = data else {return}
            
            print(data.averageActivePace)
            print(data.distance)
            print(data.floorsAscended)
            
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
