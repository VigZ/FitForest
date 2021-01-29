//
//  CreateJourneyViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import UIKit
import CoreLocation

class CreateJourneyViewController: UIViewController {
    
    private var journey: Journey?
    private let locationManager = LocationManager.sharedInstance
    private var seconds = 0 {
        didSet {
            let formattedDistance = FormatDisplay.distance(distance)
            let formattedTime = FormatDisplay.time(seconds)
            let formattedPace = FormatDisplay.pace(distance: distance,
                                                   seconds: seconds,
                                                   outputUnit: UnitSpeed.minutesPerMile)
             
            distanceLabel.text = "Distance:  \(formattedDistance)"
            timeLabel.text = "Time:  \(formattedTime)"
            paceLabel.text = "Pace:  \(formattedPace)"
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
        
        let locationManager = LocationManager.sharedInstance
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = .white
        view.addSubview(startButton)
        view.addSubview(endButton)
        view.addSubview(distanceLabel)
        view.addSubview(timeLabel)
        view.addSubview(paceLabel)
        setUpViews()
    }
    
    private func startJourney(){
        
    }
    
    private func endJourney(){
        
    }
    
    @objc func stopTapped() {
        let alertController = UIAlertController(title: "End journey?",
                                                message: "Do you wish to end your journey?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
          self.endJourney()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
          self.endJourney()
//          _ = self.navigationController?.popToRootViewController(animated: true)
        })
            
        present(alertController, animated: true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      locationManager.stopUpdatingLocation()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateJourneyViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
      }

      locationList.append(newLocation)
    }
  }
}
