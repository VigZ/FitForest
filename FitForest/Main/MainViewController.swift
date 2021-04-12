//
//  ViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/23/21.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController, HasCustomView {
    typealias CustomView = MainView
    
    override func loadView() {
        let customView = CustomView()
        customView.delegate = self
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        FitForestHealthStore.sharedInstance.requestUserPermissions()
        StepTracker.sharedInstance.startUpdating()
    }
    
    private func registerForNotifications() {
        let ns = NotificationCenter.default
        let stepCountUpdated = Notification.Name.StepTrackerEvents.stepCountUpdated
        
        ns.addObserver(forName: stepCountUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.customView.topContainer.stepsLabel.text = String(StepTracker.sharedInstance.numberOfSteps)
                self.customView.topContainer.stateLabel.text = StepTracker.sharedInstance.currentActivity
                self.customView.topContainer.pointsLabel.text = String(GameData.sharedInstance?.points ?? 0)
            }
        }
        
    }


}

