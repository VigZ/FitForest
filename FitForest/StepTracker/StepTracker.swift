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
    
    private func startTrackingActivityType() {
      activityManager.startActivityUpdates(to: OperationQueue.main) {
          [weak self] (activity: CMMotionActivity?) in

          guard let activity = activity else { return }
          DispatchQueue.main.async {
              if activity.walking {
                print(activity)
//                  self?.activityTypeLabel.text = "Walking"
              } else if activity.stationary {
                print(activity)
//                  self?.activityTypeLabel.text = "Stationary"
              } else if activity.running {
                print(activity)
//                  self?.activityTypeLabel.text = "Running"
              } else if activity.automotive {
                print(activity)
//                  self?.activityTypeLabel.text = "Automotive"
              }
          }
      }
    }
    
    private func startCountingSteps() {
      pedometer.startUpdates(from: Date()) {
          [weak self] pedometerData, error in
          guard let pedometerData = pedometerData, error == nil else { return }

          DispatchQueue.main.async {
            print(pedometerData.numberOfSteps.stringValue)
//              self?.stepsCountLabel.text = pedometerData.numberOfSteps.stringValue
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
}
