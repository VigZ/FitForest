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
        let builder = HKWorkoutBuilder(healthStore: hkHealthStore, configuration: hkWorkoutConfig, device: nil)
       
        startWorkout(builder: builder)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//
//            builder.finishWorkout(){ (workout, error) in
//
//            }
//        }
        
    }
    
    private func startWorkout(builder: HKWorkoutBuilder){
        builder.beginCollection(withStart: Date()){
            (bool, error) in
        }
    }
    
    private func endWorkout(builder:HKWorkoutBuilder){
        builder.endCollection(withEnd: Date()){
            (bool, error) in
        }
    }
    
    func collectSteps(){
        
    }
    
    func collectDistance(){
        
    }
    
    func collectEnergyBurned(){
        
    }
}
