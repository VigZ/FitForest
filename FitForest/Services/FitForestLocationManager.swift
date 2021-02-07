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
    
    locationList.append(contentsOf: locations)
    
    let userInfoDict:[String: [CLLocation]] = ["locations": locations]
    NotificationCenter.default.post(name: Notification.Name.LocationManagerEvents.locationsUpdated, object: nil, userInfo: userInfoDict)

    // Add the filtered data to the route.
//      builderPack.routeBuilder.insertRouteData(filteredLocations) { (success, error) in
//          if !success {
//              // Handle any errors here.
//          }
//    }
  }
}
