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
        return button
    }()
    
    let endButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        return button
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
    
    private func setUpViews(){
        
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
