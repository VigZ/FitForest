//
//  StoreFrontViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 9/6/21.
//

import Foundation
import UIKit

class StoreFrontViewController: UIViewController, HasCustomView {
    typealias CustomView = StoreFrontView
    
    override func loadView() {
        let customView = CustomView()
        customView.delegate = self
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    private func registerForNotifications() {
      
        
    }

}


