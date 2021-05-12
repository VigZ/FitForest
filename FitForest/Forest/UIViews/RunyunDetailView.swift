//
//  RunyunDetailView.swift
//  FitForest
//
//  Created by Kyle Vigorito on 5/11/21.
//

import Foundation
import UIKit

class RunyunDetailView: UIView {
    
    var runyun: RunyunStorageObject!
    let nameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        let cancelButton = UITextField.ToolbarItem(title: "Cancel", target: self, selector: #selector(cancelPressed))
        let doneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(donePressed))
        field.addToolbar(leading: [cancelButton], trailing: [doneButton])
        field.placeholder = "Enter Name"
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
    
    convenience init (runyun: RunyunStorageObject, frame: CGRect){
        self.init(frame: frame)
        self.runyun = runyun
        
        setupView()
        self.nameField.text = runyun.name
        self.leafLabel.text = runyun.leafType.rawValue
        self.seedLabel.text = runyun.seedType.rawValue
        self.accessoryLabel.text = runyun.accessory?.name
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
    
    @objc func cancelPressed() {
        nameField.resignFirstResponder()
    }
    
    @objc func donePressed() {
        runyun.name = nameField.text ?? ""
        nameField.resignFirstResponder()
    }
    
    func updateRunyun(runyun:RunyunStorageObject){
        self.runyun = runyun
        self.nameField.text = runyun.name
        self.leafLabel.text = runyun.leafType.rawValue
        self.seedLabel.text = runyun.seedType.rawValue
        self.accessoryLabel.text = runyun.accessory?.name
    }


}
