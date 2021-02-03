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
    
    private var seconds = 0
//    {
//        didSet {
//            DispatchQueue.main.async {
//                let formattedDistance = FormatDisplay.distance(self.distance)
//                let formattedTime = FormatDisplay.time(self.seconds)
//                let formattedPace = FormatDisplay.pace(distance: self.distance,
//                                                       seconds: self.seconds,
//                                                       outputUnit: UnitSpeed.minutesPerMile)
//                self.distanceLabel.text = "Distance:  \(formattedDistance)"
//                self.timeLabel.text = "Time:  \(formattedTime)"
//                self.paceLabel.text = "Pace:  \(formattedPace)"
//            }
//
//        }
//    }
    private var timer: Timer?
    private var distance = Measurement(value: 0 , unit: UnitLength.meters)
    
    private var initialDistance:Double = 0
    private var initialSteps:Int = 0
    private var initialPace:Double = 0
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
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        checkPermissions()
        startLocationUpdates()
        journeyManager.startWorkout()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.seconds += 1
        }
        registerForNotifications()
    }
    
    private func endJourney(){
        journeyManager.locationManager.stopUpdatingLocation()
        journeyManager.endWorkout()
    }
    
    @objc func stopTapped() {
        let alertController = UIAlertController(title: "End journey?",
                                                message: "Do you wish to end your journey?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.endJourney()
            self.saveJourney()
            let dvc = JourneyDetailViewController()
            dvc.journey = self.journeyManager.builderPack.journeyWorkout
            self.navigationController?.pushViewController(dvc, animated: true)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.endJourney()
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
    
    private func startLocationUpdates() {
        journeyManager.locationManager.delegate = self
        journeyManager.locationManager.activityType = .fitness
        journeyManager.locationManager.distanceFilter = 10
        journeyManager.locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        journeyManager.locationManager.stopUpdatingLocation()
    }
    
    private func saveJourney() {
      let newJourney = Journey(context: CoreDataManager.context)
      newJourney.distance = distance.value
      newJourney.duration = Int16(seconds)
      newJourney.timestamp = Date()
      
      for location in locationList {
        let locationObject = Location(context: CoreDataManager.context)
        locationObject.timestamp = location.timestamp
        locationObject.latitude = location.coordinate.latitude
        locationObject.longitude = location.coordinate.longitude
        newJourney.addToLocations(locationObject)
      }
      
      CoreDataManager.saveContext()
      
    }
    
    private func registerForNotifications() {
        let ns = NotificationCenter.default
        
        let stepCountUpdated = Notification.Name.StepTrackerEvents.stepCountUpdated
        let paceUpdated = Notification.Name.StepTrackerEvents.paceUpdated
        let distanceUpdated = Notification.Name.StepTrackerEvents.distanceUpdated
        let floorsUpdated = Notification.Name.StepTrackerEvents.floorsUpdated
        
        ns.addObserver(forName: stepCountUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.stepsLabel.text = "Steps: \(String(StepTracker.sharedInstance.numberOfSteps - self.initialSteps))"
            }
        }
        
        ns.addObserver(forName: paceUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.paceLabel.text = "Pace: \(String(StepTracker.sharedInstance.averagePace - self.initialPace))"
            }
        }
        
        ns.addObserver(forName: distanceUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.distanceLabel.text = "Distance: \(String(StepTracker.sharedInstance.distance - self.initialDistance))"
            }
        }
        
        ns.addObserver(forName: floorsUpdated, object: nil, queue: nil){
            (notification) in
            DispatchQueue.main.async {
                self.floorsLabel.text = "Floors: \(String(StepTracker.sharedInstance.floorsAscended - self.initialFloors))"
            }
        }
        
    }
    
    private func setInitialValues(){
        initialSteps = StepTracker.sharedInstance.numberOfSteps
        initialPace =  StepTracker.sharedInstance.averagePace
        initialDistance = StepTracker.sharedInstance.distance
        initialFloors = StepTracker.sharedInstance.floorsAscended
    }
}

extension CreateJourneyViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Filter location data
    
    let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
        location.horizontalAccuracy <= 5.0
    }
    
    guard !filteredLocations.isEmpty else { return }
    
    locationList = filteredLocations
    // Add the filtered data to the route.
      journeyManager.builderPack.routeBuilder.insertRouteData(locationList) { (success, error) in
          if !success {
              // Handle any errors here.
          }
    }
  }
}

