//
//  RunyunDetailView.swift
//  FitForest
//
//  Created by Kyle Vigorito on 5/11/21.
//

import Foundation
import UIKit

class RunyunDetailView: UIView {
    
    let nameField: UITextField = {
        let field = UITextField()
        field.text = "Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let leafLabel: UILabel = {
        let label = UILabel()
        label.text = "LeafType"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seedLabel: UILabel = {
        let label = UILabel()
        label.text = "SeedType"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let accessoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Accessory"
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
        addSubview(nameField)
        addSubview(leafLabel)
        addSubview(seedLabel)
        addSubview(accessoryLabel)
        setupLayout()
    }

    private func setupLayout() {
      NSLayoutConstraint.activate([
        
        nameField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        nameField.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
        
        leafLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        leafLabel.centerYAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
        
        seedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        seedLabel.centerYAnchor.constraint(equalTo: leafLabel.bottomAnchor, constant: 20),
        
        accessoryLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 20),
        accessoryLabel.centerYAnchor.constraint(equalTo: seedLabel.bottomAnchor, constant: 20),
        
      ])
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }


}
