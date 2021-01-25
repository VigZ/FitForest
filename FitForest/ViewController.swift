//
//  ViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/23/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = String(StepTracker.sharedInstance.numberOfSteps)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Stationary"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = String(Inventory.sharedInstance.points)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        StepTracker.sharedInstance.startUpdating()
        
        view.backgroundColor = .white
        view.addSubview(stepsLabel)
        view.addSubview(pointsLabel)
        view.addSubview(stateLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        stepsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stepsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        stepsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stepsLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        pointsLabel.centerXAnchor.constraint(equalTo: stepsLabel.centerXAnchor, constant: 20).isActive = true
        
        stateLabel.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 150).isActive = true
        stateLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func registerForNotifications() {
        let ns = NotificationCenter.default
        let stepCountUpdated = Notification.Name.StepTrackerEvents.stepCountUpdated
        
        ns.addObserver(forName: stepCountUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.stepsLabel.text = String(StepTracker.sharedInstance.numberOfSteps)
                self.stateLabel.text = StepTracker.sharedInstance.currentActivity
                self.pointsLabel.text = String(Inventory.sharedInstance.points)
            }
        }
        
    }


}

