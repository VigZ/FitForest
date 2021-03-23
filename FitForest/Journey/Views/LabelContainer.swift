//
//  LabelContainer.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/22/21.
//

import UIKit

class LabelContainer: UIView {

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
        addSubview(distanceLabel)
        addSubview(timeLabel)
        addSubview(paceLabel)
        addSubview(stepsLabel)
        addSubview(floorsLabel)
        setupLayout()
    }

    private func setupLayout() {
      NSLayoutConstraint.activate([
        
        distanceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        distanceLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
        
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        timeLabel.centerYAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20),
        
        paceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        paceLabel.centerYAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
        
        stepsLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 20),
        stepsLabel.centerYAnchor.constraint(equalTo: paceLabel.bottomAnchor, constant: 20),
        
        floorsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        floorsLabel.centerYAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 20)
      ])
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }


}


