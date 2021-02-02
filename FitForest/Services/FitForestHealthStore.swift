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
}
