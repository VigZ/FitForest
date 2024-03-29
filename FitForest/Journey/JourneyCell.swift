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

            startDateLabel.text = FormatDisplay.date(journeyWorkout.startDate)
            startTimeLabel.text = FormatDisplay.timeOfDay(journeyWorkout.startDate)
            stepsLabel.text = String(describing: journeyWorkout.steps) + " steps"
            distanceLabel.text = FormatDisplay.distance(journeyWorkout.distance)
        }
    }
    
    private let cellContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGreen
        return container
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startTimeLabel: UILabel = {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()


    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellContainer)
        cellContainer.addSubview(startDateLabel)
        cellContainer.addSubview(startTimeLabel)
        cellContainer.addSubview(stepsLabel)
        cellContainer.addSubview(distanceLabel)
        
        // add shadow on cell
        backgroundColor = .clear // very important
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layoutMargins = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)

        startDateLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        startDateLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        startDateLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
            
        startTimeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        startTimeLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        startTimeLabel.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 10).isActive = true
            
        stepsLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stepsLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
            
        distanceLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 10).isActive = true
    
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
