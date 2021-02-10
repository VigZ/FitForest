//
//  JourneyCell.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/9/21.
//

import UIKit

class JourneyCell: UITableViewCell {
    
    var journeyWorkout: JourneyWorkout? {
        didSet {
            guard let journeyWorkout = journeyWorkout else { return }
            startDateLabel.text = String(describing:journeyWorkout.startDate)
            stepsLabel.text = String(describing: journeyWorkout.steps)
            distanceLabel.text = String(describing: journeyWorkout.distance)
        }
    }
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    addSubview(startDateLabel)
    addSubview(stepsLabel)
    addSubview(distanceLabel)

    startDateLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
    startDateLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    startDateLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        
    stepsLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
    stepsLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    stepsLabel.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 10).isActive = true
        
    distanceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 20).isActive = true

    distanceLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true

    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
