//
//  CreateJourneyViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/29/21.
//

import UIKit

class CreateJourneyViewController: UIViewController {
    
    private var journey: Journey?
    
    let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        return button
    }()
    
    let endButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End", for: .normal)
        button.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        return button
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance:"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time:"
        return label
    }()
    
    let paceLabel: UILabel = {
        let label = UILabel()
        label.text = "Pace:"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(startButton)
        view.addSubview(endButton)
        setUpViews()
    }
    
    private func startJourney(){
        
    }
    
    private func endJourney(){
        
    }
    
    @objc func stopTapped() {
        let alertController = UIAlertController(title: "End journey?",
                                                message: "Do you wish to end your journey?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
          self.endJourney()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
          self.endJourney()
//          _ = self.navigationController?.popToRootViewController(animated: true)
        })
            
        present(alertController, animated: true)
    }
    
    private func setUpViews(){
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: endButton.topAnchor, constant: -20).isActive = true
        
        endButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
