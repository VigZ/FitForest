//
//  CreateJourneyViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import UIKit
import CoreLocation
import MapKit

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
    
    private var mapView: MKMapView!
    
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
        setUpMap()
        registerForNotifications()
        
    }
    
    private func checkPermissions(){
        journeyManager.requestUserPermissions()
    }
    
    private func startJourney(){
        let newJourney = JourneyWorkout(start: Date(), end: nil)
        journeyManager = FitForestJourneyManager(journeyWorkout: newJourney)
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
                      }
                        if let lastLocation = dict["lastLocation"] as? CLLocation {
                            DispatchQueue.main.async {
                                // Add locations to map
                                
                                let coordinates = [lastLocation.coordinate, locations[0].coordinate]
                                
                                self.mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                            }
                        }

                    }
            }
    }
}
    
    private func setUpMap(){
        let mapView = MKMapView()
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        view.addSubview(mapView)
        self.mapView = mapView
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        
    }
}

extension CreateJourneyViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      
      guard let polyline = overlay as? MulticolorPolyline else {
        return MKOverlayRenderer(overlay: overlay)
          
      }
      let renderer = MKPolylineRenderer(polyline: polyline)
      renderer.strokeColor = polyline.color
      renderer.lineWidth = 5
      
      return renderer
    }
}

