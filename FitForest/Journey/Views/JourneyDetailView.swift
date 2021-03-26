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
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteSavedJourney), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: JourneyDetailViewController!
    
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
        addSubview(deleteButton)
        backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
      NSLayoutConstraint.activate([
        labelContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        labelContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        labelContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        
        deleteButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

        map.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        map.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        map.heightAnchor.constraint(equalToConstant: 300),
        map.widthAnchor.constraint(equalTo: self.widthAnchor)
      ])
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
    
    @objc func deleteSavedJourney(){
        let context = CoreDataStack.sharedInstance.context
        guard let journeyEntity =  try? delegate.journey.toCoreData(context: context) else {
            return
        }
        context.delete(journeyEntity)
 
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        delegate.delegate.setupSnapshot()
    }
}

