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
          guard let pedometerData = pedometerData, error == nil else { return }
            self?.numberOfSteps = Int(truncating: pedometerData.numberOfSteps)
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
}
