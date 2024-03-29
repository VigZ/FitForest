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
    
    var mapWorkout: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(JourneyCell.self, forCellReuseIdentifier: "JourneyCell")
        
        setupTableView()
        setupFetchedResultsController()
        registerForNotifications()
        setUpNavBar()
        
    }
    
    private func setupTableView() {
        diffableDataSource = UITableViewDiffableDataSource<JourneySection, Journey>(tableView: tableView) { (tableView, indexPath, journey) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyCell", for: indexPath) as! JourneyCell
            
            cell.journeyWorkout = JourneyWorkout(journey: journey)
            
            return cell
        }
        
        setupSnapshot()
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
    }

    func setupSnapshot() {
        diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<JourneySection, Journey>()
        diffableDataSourceSnapshot.appendSections([JourneySection.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
        print("Current number of items:")
        print(diffableDataSourceSnapshot.numberOfItems)
        diffableDataSource?.apply(self.diffableDataSourceSnapshot)
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Journey> = Journey.fetchRequest()
        request.fetchBatchSize = 30
        
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        request.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.sharedInstance.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        fetch()

    }
    
    func fetch(){
        do {
            try fetchedResultsController.performFetch()
         
            setupSnapshot()
        } catch {
            //  TODO Add Error handling here.
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = .clear
        cell.contentView.layer.zPosition = -1
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let createButton = UIButton()
        createButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        createButton.setTitle("Start Journey", for: .normal)
        createButton.frame = CGRect(x: 0, y: 0, width: 150, height: 90)

        topView.addSubview(createButton)
        
        let trackToggle = UISwitch()
        trackToggle.isOn = true
        trackToggle.addTarget(self, action: #selector(self.mapWorkoutToggled), for: UIControl.Event.valueChanged)

        topView.addSubview(trackToggle)
        topView.layer.cornerRadius = 25
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

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
        vc.mapToggle = mapWorkout
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
        var snapshot = diffableDataSourceSnapshot
        snapshot.deleteItems([itemToDelete])
        diffableDataSource?.apply(snapshot)
//        fetch()
    }
    
    @objc func mapWorkoutToggled(){
        mapWorkout.toggle()
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationBar.barTintColor = .systemGreen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

extension JourneyTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       setupSnapshot()
    }

}



