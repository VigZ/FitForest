//
//  StepTracker.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/23/21.
//

import Foundation
import CoreMotion

class StepTracker {
    
    static let sharedInstance = StepTracker()
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var currentActivity: String = "Stationary"
    
    var numberOfSteps: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.StepTrackerEvents.stepCountUpdated, object: self)
        }
    }
    
    var averagePace: Double = 0.0
    var distance: Double = 0.0
    var floorsAscended: Int = 0

    
    private func startTrackingActivityType() {
      activityManager.startActivityUpdates(to: OperationQueue.main) {
          [weak self] (activity: CMMotionActivity?) in

          guard let activity = activity else { return }
              if activity.walking {
                self?.currentActivity = "Walking"
              } else if activity.stationary {
                self?.currentActivity = "Stationary"
              } else if activity.running {
                self?.currentActivity = "Running"
              } else if activity.automotive || activity.cycling {
                self?.currentActivity = "Cruising"
              }
      }
    }
    
    private func startCountingSteps() {
      pedometer.startUpdates(from: Date()) {
          [weak self] pedometerData, error in
        guard let pedometerData = pedometerData, error == nil, let previousSteps = self?.numberOfSteps else { return }
            self?.numberOfSteps = Int(truncating: pedometerData.numberOfSteps)
            guard let steps = self?.numberOfSteps else { return }
        // Math for point updates
            let stepDifference = steps - previousSteps
        GameData.sharedInstance.points += stepDifference /  PointConstants.pointDivision.rawValue//roughly 3 steps for every point. This will be changed later, as updates under 3 steps earn no points.
        
        // Update other data
        if let dataDistance = pedometerData.distance {
            self?.distance = dataDistance.doubleValue
        }
        
        if let dataPace = pedometerData.averageActivePace {
            self?.averagePace = dataPace.doubleValue
        }
        
        if let dataFloors = pedometerData.floorsAscended {
            self?.floorsAscended = dataFloors.intValue
        }
      }
    }
    
    func startUpdating() {
      if CMMotionActivityManager.isActivityAvailable() {
          startTrackingActivityType()
      }

      if CMPedometer.isStepCountingAvailable() {
          startCountingSteps()
      }
    }
    
    func queryPedometer(from: Date, to: Date, withHandler: @escaping CMPedometerHandler){
        pedometer.queryPedometerData(from: from, to: to, withHandler: withHandler)
    }
}
