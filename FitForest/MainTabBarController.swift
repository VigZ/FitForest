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
        let tabOneImage = UIImage(systemName: "house.circle")
        let selectedTabOneImage = UIImage(systemName: "house.circle.fill")
        let tabOneBarItem = UITabBarItem(title: "Home", image: tabOneImage, selectedImage: selectedTabOneImage)
        
        tabOne.tabBarItem = tabOneBarItem
        
        // Create Second Tab
        let tabTwo = CreateJourneyViewController()
        // Embed in Navigation Controller
        let tabTwoNav = UINavigationController(rootViewController: tabTwo)
        let tabTwoImage = UIImage(systemName: "figure.walk.circle")
        let selectedTabTwoImage = UIImage(systemName: "figure.walk.circle.fill")
        let tabTwoBarItem = UITabBarItem(title: "Journey", image: tabTwoImage, selectedImage: selectedTabTwoImage)
        
        tabTwoNav.tabBarItem = tabTwoBarItem
        
        // Create Third Tab
        let tabThree = JourneyTableViewController()
        // Embed in Navigation Controller
        let tabThreeImage = UIImage(systemName: "table")
        let selectedTabThreeImage = UIImage(systemName: "table.fill")
        let tabThreeBarItem = UITabBarItem(title: "JourneyTable", image: tabThreeImage, selectedImage: selectedTabThreeImage)
        
        tabThree.tabBarItem = tabThreeBarItem
        
        // Add ViewControllers
        self.viewControllers = [tabOne, tabTwoNav, tabThree]
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

