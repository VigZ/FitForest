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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(JourneyCell.self, forCellReuseIdentifier: "JourneyCell")
        
        setupTableView()
        setupFetchedResultsController()
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

    private func setupSnapshot() {
        diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<JourneySection, Journey>()
        diffableDataSourceSnapshot.appendSections([JourneySection.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
        diffableDataSource?.apply(self.diffableDataSourceSnapshot)
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Journey> = Journey.fetchRequest()
        request.fetchBatchSize = 30
        
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
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
        navigationController?.pushViewController(dvc, animated: true)
    }

}

extension JourneyTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       setupSnapshot()
    }

}



