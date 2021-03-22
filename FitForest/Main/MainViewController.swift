//
//  ViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/23/21.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController {
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "Steps: \(StepTracker.sharedInstance.numberOfSteps)"
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
        label.text = "Gems: \(Inventory.sharedInstance.points)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upperContainer: UIView = {
        let upperContainer = UIView()
        upperContainer.backgroundColor = .systemGreen
        upperContainer.translatesAutoresizingMaskIntoConstraints = false
        return upperContainer
    }()
    
    let lowerContainer: UIView = {
        let lowerContainer = UIView()
        lowerContainer.backgroundColor = .systemPurple
        lowerContainer.translatesAutoresizingMaskIntoConstraints = false
        return lowerContainer
    }()
    
    override func loadView() {
        let mainView = MainView()
        mainView.delegate = self
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        StepTracker.sharedInstance.startUpdating()
        
        view.backgroundColor = .white
        view.addSubview(stepsLabel)
        view.addSubview(pointsLabel)
        view.addSubview(stateLabel)
        view.addSubview(upperContainer)
        view.addSubview(lowerContainer)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        upperContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        upperContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        upperContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        upperContainer.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        lowerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        lowerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        lowerContainer.topAnchor.constraint(equalTo: upperContainer.bottomAnchor).isActive = true
        lowerContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        pointsLabel.trailingAnchor.constraint(equalTo: upperContainer.trailingAnchor, constant: -10).isActive = true
        pointsLabel.topAnchor.constraint(equalTo: upperContainer.topAnchor, constant: 10).isActive = true
        
        pointsLabel.layer.zPosition = 1
        stepsLabel.centerXAnchor.constraint(equalTo: upperContainer.centerXAnchor).isActive = true
        stepsLabel.centerYAnchor.constraint(equalTo: upperContainer.centerYAnchor).isActive = true
        stepsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stepsLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stepsLabel.font = stepsLabel.font.withSize(40)
        stepsLabel.layer.zPosition = 1
      
        stateLabel.centerXAnchor.constraint(equalTo: upperContainer.centerXAnchor).isActive = true

        stateLabel.bottomAnchor.constraint(equalTo: upperContainer.bottomAnchor, constant: 0).isActive = true
        stateLabel.layer.zPosition = 1
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

