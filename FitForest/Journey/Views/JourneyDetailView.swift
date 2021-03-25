//
//  JourneyDetailView.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/22/21.
//

import UIKit
import MapKit

class JourneyDetailView: UIView {
    
    lazy var labelContainer: LabelContainer = {
        let container = LabelContainer()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var map: MKMapView = {
        let map = MKMapView(frame: UIScreen.main.bounds) // THE FRAME IS NEEDED BECAUSE OF SDK BUG
        map.mapType = MKMapType.standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.userTrackingMode = .follow
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
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
        addSubview(map)
        backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
      NSLayoutConstraint.activate([
        labelContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        labelContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        labelContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),

        map.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        map.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        map.heightAnchor.constraint(equalToConstant: 300),
        map.widthAnchor.constraint(equalTo: self.widthAnchor)
      ])
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
}

