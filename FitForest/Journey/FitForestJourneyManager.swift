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
    var locationList = [CLLocation]()
    
    
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
        
        let workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: hkHealthStore, device: nil)
        
        self.builderPack = BuilderPack(journeyWorkout:journeyWorkout, routeBuilder: workoutRouteBuilder)
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
    
    func createWorkout(){
        
        let endDate = Date()
        
        let startDate = builderPack.journeyWorkout.start
        
        // Create workout with data
        collectData(startDate: startDate, endDate: endDate)
        
        // Map Struct to Entity
        
        let journeyEntity = Journey(entity: NSEntityDescription, insertInto: CoreDataManager.sharedInstance.context)
        
        // Save Entity to Core Data
        

    }
    
    private func collectData(startDate: Date, endDate: Date){

        //TODO: Need to add error handling when using simulator and pedometer data unavailable.
        
        // Query StepTracker for step data during workout
        stepCounter.queryPedometer(from: startDate, to: endDate) { [self] (data, error) in

            guard let data = data else {return}
            
            // Add data to JourneyWorkout
            self.builderPack.journeyWorkout.end = endDate
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
                guard !success else {
                    //Handle error
                    return
                }
                // Create Samples
                self.fitForestHealthStore.hkHealthStore?.add([stepSample, distanceSample, calorieSample], to: newWorkout){  (success, error) in
                }

            }
            // Create, save, and associate the route with the provided workout.
            self.builderPack.routeBuilder.finishRoute(with: newWorkout, metadata: nil) { (newRoute, error) in

                        guard newRoute != nil else {
                            // Handle any errors here.
                            return
                        }
                
                        // Optional: Do something with the route here.
                    }
        }
    }
    
     func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
}

extension FitForestJourneyManager: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Filter location data
    
    let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
        location.horizontalAccuracy <= 20.0
    }
    
    guard !filteredLocations.isEmpty else { return }
    
    locationList.append(contentsOf: locations)
    // Add the filtered data to the route.
      builderPack.routeBuilder.insertRouteData(filteredLocations) { (success, error) in
          if !success {
              // Handle any errors here.
          }
    }
  }
}
