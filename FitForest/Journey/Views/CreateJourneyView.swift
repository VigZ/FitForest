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
    
    lazy var map: MKMapView = {
        let map = MKMapView(frame: UIScreen.main.bounds) // THE FRAME IS NEEDED BECAUSE OF SDK BUG
        map.mapType = MKMapType.standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.userTrackingMode = .follow
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
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
        addSubview(map)
        backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
      NSLayoutConstraint.activate([
        labelContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        labelContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        labelContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        endButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        endButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        map.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        map.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        map.heightAnchor.constraint(equalToConstant: 300),
        map.widthAnchor.constraint(equalTo: self.widthAnchor)
      ])
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
