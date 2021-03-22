//
//  CreateJourneyView.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/22/21.
//

import UIKit
import MapKit

class CreateJourneyView: UIView {

    lazy var labelContainer: LabelContainer = {
        let container = LabelContainer()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let endButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End", for: .normal)
        button.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        return button
    }()
    
    private var mapView: MKMapView!
    
    weak var delegate:CreateJourneyViewController!

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }

    private func setupView() {
        addSubview(labelContainer)
        addSubview(endButton)
        setUpMap()
        backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
      NSLayoutConstraint.activate([
        labelContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        labelContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        labelContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        endButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        endButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
      ])
    }
    
    private func setUpMap(){
        let mapView = MKMapView()
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = self.frame.size.width-20
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = self.center
        self.addSubview(mapView)
        self.mapView = mapView
        mapView.delegate = self
        mapView.userTrackingMode = .follow
    }
    
    @objc func stopTapped() {
        // TODO Fix memory leak that is probably here.
        let alertController = UIAlertController(title: "End journey?",
                                                message: "Do you wish to end your journey?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.delegate.endJourney(save: true)
            let dvc = JourneyDetailViewController()
            dvc.journey = self.delegate.journeyManager.builderPack.journeyWorkout
            let presenting = self.delegate.presentingViewController
            self.delegate.dismiss(animated: true){
                presenting?.present(dvc, animated: true, completion: nil)
            }
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.delegate.endJourney(save: false)
            self.delegate.dismiss(animated: true, completion: nil)
        })
        
        delegate.timer?.invalidate()
            
        delegate.present(alertController, animated: true)
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

}


extension CreateJourneyView: MKMapViewDelegate {
    
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
