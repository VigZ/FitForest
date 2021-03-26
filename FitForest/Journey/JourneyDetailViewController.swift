//
//  JourneyDetailViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import UIKit
import MapKit

class JourneyDetailViewController: UIViewController, HasCustomView {
    typealias CustomView = JourneyDetailView
    
    var journey: JourneyWorkout!
    weak var delegate: JourneyTableViewController!
    
    override func loadView() {
        let customView = CustomView()
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        customView.delegate = self
        customView.map.delegate = self
        configureView()
        loadMap()
    }
    
    private func configureView() {
        let distance = Measurement(value: journey.distance, unit: UnitLength.meters)
        let seconds = Int(journey.duration ?? 0)
        let formattedDistance = FormatDisplay.distance(distance)
//        let formattedDate = FormatDisplay.date(journey.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                             seconds: seconds,
                                             outputUnit: UnitSpeed.minutesPerMile)
      
        customView.labelContainer.distanceLabel.text = "Distance:  \(formattedDistance)"
//      dateLabel.text = formattedDate
        customView.labelContainer.timeLabel.text = "Time:  \(formattedTime)"
        customView.labelContainer.paceLabel.text = "Pace:  \(formattedPace)"
        customView.labelContainer.stepsLabel.text = "Steps:  \(journey.steps)"
        let capitalizedRank = "\(journey.ranking)".localizedCapitalized
        customView.labelContainer.rankingLabel.text = "Rank:  \(capitalizedRank)"
//      customView.labelContainer.floorsLabel.text = "Floors:  \(journey.floorsAscended)"
//      Need to add floors ascended to journey struct.
    }
    
    
    
    private func mapRegion() -> MKCoordinateRegion? {
      guard
        journey.locations.count > 0
      else {
        return nil
      }
        let latitudes = journey.locations.map { location -> Double in
        return location.latitude
      }
      
        let longitudes = journey.locations.map { location -> Double in
        return location.longitude
      }
      
      let maxLat = latitudes.max()!
      let minLat = latitudes.min()!
      let maxLong = longitudes.max()!
      let minLong = longitudes.min()!
      
      let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                          longitude: (minLong + maxLong) / 2)
      let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2,
                                  longitudeDelta: (maxLong - minLong) * 2)
      return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> [MulticolorPolyline] {
      // 1
        let locations = journey.locations.sorted {
            return $0.timestamp! < $1.timestamp!
        }
      var coordinates: [(CLLocation, CLLocation)] = []
      var speeds: [Double] = []
      var minSpeed = Double.greatestFiniteMagnitude
      var maxSpeed = 0.0
      
      // 2
      for (first, second) in zip(locations, locations.dropFirst()) {
        let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
        let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
        coordinates.append((start, end))
        //3
        let distance = end.distance(from: start)
        let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
        let speed = time > 0 ? distance / time : 0
        speeds.append(speed)
        minSpeed = min(minSpeed, speed)
        maxSpeed = max(maxSpeed, speed)
      }
      
      //4
      let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
      
      //5
      var segments: [MulticolorPolyline] = []
      for ((start, end), speed) in zip(coordinates, speeds) {
        
        let coords = [start.coordinate, end.coordinate]
        let segment = MulticolorPolyline(coordinates: coords, count: 2)
        segment.color = segmentColor(speed: speed,
                                     midSpeed: midSpeed,
                                     slowestSpeed: minSpeed,
                                     fastestSpeed: maxSpeed)
        segments.append(segment)
      }
        
      return segments
    }
    
    private func loadMap() {
      guard
        journey.locations.count > 0,
        let region = mapRegion()
      else {
          let alert = UIAlertController(title: "Error",
                                        message: "Sorry, this journey has no locations saved",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel))
          present(alert, animated: true)
          return
      }
        customView.map.setRegion(region, animated: true)
        customView.map.addOverlays(polyLine())
    }
    
    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
      enum BaseColors {
        static let r_red: CGFloat = 1
        static let r_green: CGFloat = 20 / 255
        static let r_blue: CGFloat = 44 / 255
        
        static let y_red: CGFloat = 1
        static let y_green: CGFloat = 215 / 255
        static let y_blue: CGFloat = 0
        
        static let g_red: CGFloat = 0
        static let g_green: CGFloat = 146 / 255
        static let g_blue: CGFloat = 78 / 255
      }
      
      let red, green, blue: CGFloat
      
      if speed < midSpeed {
        let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
        red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
        green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
        blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
      } else {
        let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
        red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
        green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
        blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
      }
      
      return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
  }

extension JourneyDetailViewController: MKMapViewDelegate {
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
