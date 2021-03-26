//
//  JourneyTableViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 2/7/21.
//

import UIKit
import CoreData

class JourneyTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Journey>!
    
    var diffableDataSource: UITableViewDiffableDataSource<JourneySection, Journey>?
    var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<JourneySection, Journey>()
    
    let topView: UIView = {
        let tv = UIView()
        tv.frame.size.height = 100
        tv.backgroundColor = UIColor.systemGreen
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(JourneyCell.self, forCellReuseIdentifier: "JourneyCell")
        
        setupTableView()
        setupFetchedResultsController()
        registerForNotifications()
        
    }
    
    private func setupTableView() {
        diffableDataSource = UITableViewDiffableDataSource<JourneySection, Journey>(tableView: tableView) { (tableView, indexPath, journey) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyCell", for: indexPath) as! JourneyCell
            
            cell.journeyWorkout = JourneyWorkout(journey: journey)
            
            return cell
        }
        
        setupSnapshot()
        tableView.rowHeight = 60
    }

    func setupSnapshot() {
        diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<JourneySection, Journey>()
        diffableDataSourceSnapshot.appendSections([JourneySection.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
        diffableDataSource?.apply(self.diffableDataSourceSnapshot)
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Journey> = Journey.fetchRequest()
        request.fetchBatchSize = 30
        
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        request.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.sharedInstance.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            setupSnapshot()
        } catch {
            print("Fetch failed")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let journey = diffableDataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        let journeyWorkout = JourneyWorkout(journey: journey)
        
        let dvc = JourneyDetailViewController()
        dvc.journey = journeyWorkout
        dvc.delegate = self
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let createButton = UIButton()
        createButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        createButton.setTitle("Start Journey", for: .normal)
        createButton.frame = CGRect(x: 0, y: 0, width: 150, height: 90)

        topView.addSubview(createButton)

        return topView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 175
    }
    
    @objc func startTapped() {
        let authStatus = FitForestLocationManager.sharedInstance.locationManager.authorizationStatus
        guard authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse else {
            FitForestLocationManager.sharedInstance.requestLocationPermissions()
            return
        }
            createJourneyController()
    }
    
    func createJourneyController(){
        let vc = CreateJourneyViewController()
        let newJourney = JourneyWorkout(start: Date(), end: nil)
        let journeyManager = FitForestJourneyManager(journeyWorkout: newJourney)
        vc.journeyManager = journeyManager
        self.present(vc, animated: true, completion: nil)
    }
    
    private func registerForNotifications(){
        let ns = NotificationCenter.default
        let locationPermissionsChanged = Notification.Name.LocationManagerEvents.locationPermissionsChanged
        ns.addObserver(forName: locationPermissionsChanged, object: nil, queue: nil){
           [weak self] (notification) in
            self?.createJourneyController()
        }
    }
    
    func deleteItem(itemToDelete:Journey){
        var currentSnapshot = diffableDataSourceSnapshot
        currentSnapshot.deleteItems([itemToDelete])
        if let diffableDataSource = diffableDataSource {
            diffableDataSource.apply(currentSnapshot)
        }
       
    }
}

extension JourneyTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       setupSnapshot()
    }

}



