//
//  ViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/23/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = String(Inventory.sharedInstance.points)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Stationary"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        StepTracker.sharedInstance.startUpdating()
        
        view.backgroundColor = .white
        view.addSubview(pointsLabel)
        view.addSubview(stateLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        pointsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pointsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        pointsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pointsLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
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
                self.pointsLabel.text = String(StepTracker.sharedInstance.numberOfSteps)
                self.stateLabel.text = StepTracker.sharedInstance.currentActivity
            }
        }
        
    }


}

