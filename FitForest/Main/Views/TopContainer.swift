//
//  TopContainer.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/22/21.
//

import UIKit

class TopContainer: UIView {

    let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "Steps: \(StepTracker.sharedInstance.numberOfSteps)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Stationary"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Gems: \(Inventory.sharedInstance.points)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        backgroundColor = .systemGreen
        addSubview(stepsLabel)
        addSubview(stateLabel)
        addSubview(pointsLabel)
        setupLayout()
    }

    private func setupLayout() {        
      NSLayoutConstraint.activate([
        
        pointsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        pointsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),

        stepsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        stepsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        stepsLabel.widthAnchor.constraint(equalToConstant: 200),
        stepsLabel.heightAnchor.constraint(equalToConstant: 200),

        stateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        stateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
      ])
        
        pointsLabel.layer.zPosition = 1
        
        stepsLabel.font = stepsLabel.font.withSize(40)
        stepsLabel.layer.zPosition = 1
        
        stateLabel.layer.zPosition = 1
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

}

