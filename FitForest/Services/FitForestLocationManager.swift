//
//  LocationManager.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import Foundation
import CoreLocation

class FitForestLocationManager: NSObject {
    static let sharedInstance = FitForestLocationManager()
    
    let locationManager = CLLocationManager()
    
    var locationList = [CLLocation]()
    
    override init() {
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.activityType = .fitness
    }
    
    func locationServicesAreEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationList = [CLLocation]()
    }
}

extension FitForestLocationManager: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Filter location data
    
    let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
        location.horizontalAccuracy <= 20.0
    }

    guard !filteredLocations.isEmpty else { return }

    let lastLocation = locationList.last
    
    locationList.append(contentsOf: locations)
    
    let userInfoDict:[String: Any] = ["locations": locations, "lastLocation": lastLocation as Any]
    NotificationCenter.default.post(name: Notification.Name.LocationManagerEvents.locationsUpdated, object: nil, userInfo: userInfoDict)

  }
}
