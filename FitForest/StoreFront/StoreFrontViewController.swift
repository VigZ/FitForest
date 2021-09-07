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
    
    var tabsView: StoreFrontTabBar!
    
    var currentIndex: Int = 0
    
    var pageController: UIPageViewController!
    
    override func loadView() {
        let customView = CustomView()
        customView.delegate = self
        view = customView
        tabsView = StoreFrontTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupPageViewController()

        
    }
    
    func setupTabs() {
        // Add Tabs (Set 'icon'to nil if you don't want to have icons)
        self.view.addSubview(tabsView)
        tabsView.tabs = [
            StoreTab(icon: UIImage(named: "leaf"), title: "Seeds"),
            StoreTab(icon: UIImage(named: "gift"), title: "Toys"),
            StoreTab(icon: UIImage(named: "crown"), title: "Accessories")
        ]
        
        // Set TabMode to '.fixed' for stretched tabs in full width of screen or '.scrollable' for scrolling to see all tabs
        tabsView.tabMode = .fixed
        
        // TabView Customization
        tabsView.titleColor = .white
        tabsView.iconColor = .white
        tabsView.indicatorColor = .white
        tabsView.titleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        tabsView.collectionView.backgroundColor = .cyan
        
        // Set TabsView Delegate
        tabsView.delegate = self
        
        // Set the selected Tab when the app starts
        tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        
        let sfv = view as! StoreFrontView
        
        tabsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tabsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tabsView.topAnchor.constraint(equalTo: sfv.header.bottomAnchor),
            tabsView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func setupPageViewController() {
        // PageViewController
        self.pageController = StoreTabPageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        
        // Set PageViewController Delegate & DataSource
        pageController.delegate = self
        pageController.dataSource = self
        
        // Set the selected ViewController in the PageViewController when the app starts
        pageController.setViewControllers([showViewController(0)!], direction: .forward, animated: true, completion: nil)
        
        // PageViewController Constraints
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageController.view.topAnchor.constraint(equalTo: self.tabsView.bottomAnchor),
            self.pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.pageController.didMove(toParent: self)
    }
}

extension StoreFrontViewController: TabsDelegate {
    func tabsViewDidSelectItemAt(position: Int) {
        // Check if the selected tab cell position is the same with the current position in pageController, if not, then go forward or backward
        if position != currentIndex {
            if position > currentIndex {
                self.pageController.setViewControllers([showViewController(position)!], direction: .forward, animated: true, completion: nil)
            } else {
                self.pageController.setViewControllers([showViewController(position)!], direction: .reverse, animated: true, completion: nil)
            }
            tabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension StoreFrontViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // return ViewController when go forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        // Don't do anything when viewpager reach the number of tabs
        if index == tabsView.tabs.count {
            return nil
        } else {
            index += 1
            return self.showViewController(index)
        }
    }
    
    // return ViewController when go backward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        
        if index == 0 {
            return nil
        } else {
            index -= 1
            return self.showViewController(index)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                guard let vc = pageViewController.viewControllers?.first else { return }
                let index: Int
                
                index = getVCPageIndex(vc)
                
                tabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                // Animate the tab in the TabsView to be centered when you are scrolling using .scrollable
                tabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // Return the current position that is saved in the UIViewControllers we have in the UIPageViewController
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        let vc = viewController as! StoreFrontCollectionViewController
        return vc.pageIndex
    }
    
    // Show ViewController for the current position
    func showViewController(_ index: Int) -> UIViewController? {
        if (self.tabsView.tabs.count == 0) || (index >= self.tabsView.tabs.count) {
            return nil
        }
        
        let items = [StoreItem(name: "Test", description: "Testing", classIdentifier: "Ball", price: 200), StoreItem(name: "Test", description: "Testing", classIdentifier: "Ball", price: 200), StoreItem(name: "Test", description: "Testing", classIdentifier: "Ball", price: 200)]
        currentIndex = index
        // TODO: Implement custom logic.
        if index == 0 {
            let vc = StoreFrontCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), items: items)
            vc.pageIndex = index
            return vc
        } else if index == 1 {
            let vc = StoreFrontCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), items: [items[0]])
            vc.pageIndex = index
            return vc
        } else if index == 2 {
            let vc = StoreFrontCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), items: [items[0]])
            vc.pageIndex = index
            return vc
        } else {
            let vc = StoreFrontCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), items: items)
            vc.pageIndex = index
            return vc
        }
    }
}


