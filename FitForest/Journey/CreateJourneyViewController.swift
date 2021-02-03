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
        didSet {
            DispatchQueue.main.async {
                let formattedDistance = FormatDisplay.distance(self.distance)
                let formattedTime = FormatDisplay.time(self.seconds)
                let formattedPace = FormatDisplay.pace(distance: self.distance,
                                                       seconds: self.seconds,
                                                       outputUnit: UnitSpeed.minutesPerMile)
                self.distanceLabel.text = "Distance:  \(formattedDistance)"
                self.timeLabel.text = "Time:  \(formattedTime)"
                self.paceLabel.text = "Pace:  \(formattedPace)"
            }

        }
    }
    private var timer: Timer?
    private var distance = Measurement(value: 0 , unit: UnitLength.meters)
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
        label.text = "Distance:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paceLabel: UILabel = {
        let label = UILabel()
        label.text = "Pace:"
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.seconds += 1
        }
        checkPermissions()
        startLocationUpdates()
        journeyManager.startWorkout()
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

