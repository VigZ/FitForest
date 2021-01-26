//
//  MainTabBarController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 1/26/21.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createTabBarItems()
        
    }
    
    private func createTabBarItems() {
        
        // Create First Tab
        let tabOne = MainViewController()
        let tabOneImage = UIImage(systemName: "figure.walk.circle")
        let selectedTabOneImage = UIImage(systemName: "figure.walk.circle.fill")
        let tabOneBarItem = UITabBarItem(title: "Home", image: tabOneImage, selectedImage: selectedTabOneImage)
        
        tabOne.tabBarItem = tabOneBarItem
        
        // Add ViewControllers
        self.viewControllers = [tabOne]
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

