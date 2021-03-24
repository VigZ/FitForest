//
//  CreateJourneyViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import UIKit
import CoreLocation
import MapKit

class CreateJourneyViewController: UIViewController, HasCustomView {
    typealias CustomView = CreateJourneyView
    var journeyManager: FitForestJourneyManager!
    
    private var seconds = 0 {
        didSet{
            self.customView.labelContainer.timeLabel.text = "Time: \(String(seconds))"
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
                    self.customView.labelContainer.distanceLabel.text = "Distance:  \(formattedDistance)"
                    self.customView.labelContainer.timeLabel.text = "Time:  \(formattedTime)"
                    self.customView.labelContainer.paceLabel.text = "Pace:  \(formattedPace)"
                    self.customView.labelContainer.stepsLabel.text = "Steps:  \(steps)"
                    self.customView.labelContainer.floorsLabel.text = "Floors Ascended:  \(floors)"
                }
        }
    }

    var timer: Timer?
    
    private var initialDistance: Double = 0
    private var initialSteps: Int = 0
    private var initialPace: Double = 0
    private var initialFloors = 0
    
    override func loadView() {
        let customView = CustomView()
        customView.delegate = self
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerForNotifications()
        customView.delegate = self
        customView.map.delegate = self
        startJourney()
    }
    
    private func startJourney(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.seconds += 1
        }
        setInitialValues()
    }
    
     func endJourney(save: Bool){
        journeyManager.locationManager.stopUpdatingLocation()
        guard save else {
            // Hand discard Logic
            return
        }
        journeyManager.createWorkout()
    }
    
    @objc func startTapped() {
        startJourney()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if journeyManager.locationManager.locationServicesAreEnabled(){
            journeyManager.startLocationUpdates()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func setInitialValues(){
        clearValues()
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
                // Add to route builder
                if let dict = notification.userInfo {
                    if let locations = dict["locations"] as? [CLLocation]{
                        
                        // do something
                        self.journeyManager.builderPack.routeBuilder.insertRouteData(locations) { (success, error) in
                            
                            if !success {
                                // Handle any errors here.
                            }

                            for location in locations {
                                
                                let newLocation = Location(context: self.journeyManager.coreDataStack.context)
                                newLocation.setValue(location.coordinate.latitude, forKey: "latitude")
                                newLocation.setValue(location.coordinate.longitude, forKey: "longitude")
                                newLocation.setValue(location.timestamp, forKey: "timestamp")
                                self.journeyManager.builderPack.journeyWorkout.locations.insert(newLocation)
                            }
                      }
                        
                        if let lastLocation = dict["lastLocation"] as? CLLocation {
                            DispatchQueue.main.async {
                                // Add locations to map
                                
                                let coordinates = [lastLocation.coordinate, locations[0].coordinate]
                                
                                self.customView.map.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                            }
                        }

                    }
            }
    }
}
}

extension CreateJourneyViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      
      guard let polyline = overlay as? MKPolyline else {
        
        return MKOverlayRenderer(overlay: overlay)
          
      }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = UIColor.systemBlue
    renderer.lineWidth = 5
      
      return renderer
    }
}


