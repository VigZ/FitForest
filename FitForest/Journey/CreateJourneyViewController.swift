//
//  CreateJourneyViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import UIKit
import CoreLocation

class CreateJourneyViewController: UIViewController {
    
    private var journeyManager: FitForestJourneyManager!
    
    private var seconds = 0 {
        didSet{
            self.timeLabel.text = "Time: \(String(seconds))"
                DispatchQueue.main.async {
                    let newDistance = StepTracker.sharedInstance.distance - self.initialDistance
                    let steps = StepTracker.sharedInstance.numberOfSteps - self.initialSteps
                    let floors =  StepTracker.sharedInstance.floorsAscended
                    let distanceMeasurement = Measurement(value: newDistance, unit: UnitLength.meters )
                    
                    let formattedDistance = FormatDisplay.distance(newDistance)
                    let formattedTime = FormatDisplay.time(self.seconds)
                    let formattedPace = FormatDisplay.pace(distance: distanceMeasurement,
                                                           seconds: self.seconds,
                                                           outputUnit: UnitSpeed.minutesPerMile)
                    self.distanceLabel.text = "Distance:  \(formattedDistance)"
                    self.timeLabel.text = "Time:  \(formattedTime)"
                    self.paceLabel.text = "Pace:  \(formattedPace)"
                    self.stepsLabel.text = "Steps:  \(steps)"
                    self.floorsLabel.text = "Floors Ascended:  \(floors)"
                }
        }
    }

    private var timer: Timer?
    
    private var initialDistance: Double = 0
    private var initialSteps: Int = 0
    private var initialPace: Double = 0
    private var initialFloors = 0
    
    private var locationList: [CLLocation] = []
    
    let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }()
    
    let endButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End", for: .normal)
        button.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        return button
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paceLabel: UILabel = {
        let label = UILabel()
        label.text = "Pace: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "Steps: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let floorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Floors Ascended: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .white
        view.addSubview(startButton)
        view.addSubview(endButton)
        view.addSubview(distanceLabel)
        view.addSubview(timeLabel)
        view.addSubview(paceLabel)
        view.addSubview(stepsLabel)
        view.addSubview(floorsLabel)
        setUpViews()
        
    }
    
    private func checkPermissions(){
        journeyManager.requestUserPermissions()
    }
    
    private func startJourney(){
        let newJourney = JourneyWorkout(start: Date(), end: nil)
        journeyManager = FitForestJourneyManager(journeyWorkout: newJourney)
        clearValues()
        locationList.removeAll()
        checkPermissions()
        journeyManager.startLocationUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.seconds += 1
        }
        setInitialValues()
    }
    
    private func endJourney(save: Bool){
        journeyManager.locationManager.stopUpdatingLocation()
        guard save else {
            // Hand discard Logic
            return
        }
        journeyManager.createWorkout()
    }
    
    @objc func stopTapped() {
        let alertController = UIAlertController(title: "End journey?",
                                                message: "Do you wish to end your journey?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.endJourney(save: true)
            let dvc = JourneyDetailViewController()
            dvc.journey = self.journeyManager.builderPack.journeyWorkout
            self.navigationController?.pushViewController(dvc, animated: true)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.endJourney(save: false)
        })
        
        timer?.invalidate()
            
        present(alertController, animated: true)
    }
    
    @objc func startTapped() {
        startJourney()
    }
    
    private func setUpViews(){
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: endButton.topAnchor, constant: -20).isActive = true
        
        endButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        distanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20).isActive = true
        
        paceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        paceLabel.centerYAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
        
        stepsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stepsLabel.centerYAnchor.constraint(equalTo: paceLabel.bottomAnchor, constant: 20).isActive = true
        
        floorsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        floorsLabel.centerYAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func setInitialValues(){
        initialSteps = StepTracker.sharedInstance.numberOfSteps
        initialPace =  StepTracker.sharedInstance.averagePace
        initialDistance = StepTracker.sharedInstance.distance
        initialFloors = StepTracker.sharedInstance.floorsAscended
    }
    
    private func clearValues(){
        seconds = 0
        initialSteps = 0
        initialPace =  0
        initialDistance = 0
        initialFloors = 0
    }
    
    private func registerForNotifications() {
        let ns = NotificationCenter.default
        let locationsUpdated = Notification.Name.LocationManagerEvents.locationsUpdated
        
        ns.addObserver(forName: locationsUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                // Add locations to location map and add to route builder
            }
        }
        
    }
}


