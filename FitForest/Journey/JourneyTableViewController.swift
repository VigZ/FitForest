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
        
//        dataSource = UITableViewDiffableDataSource<JourneySection, Journey>(tableView: self) {
//            (tableView: UITableView, indexPath: IndexPath, itemIdentifier: UUID) -> UITableViewCell? in
//            // configure and return cell
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupTableView() {
        diffableDataSource = UITableViewDiffableDataSource<JourneySection, Journey>(tableView: tableView) { (tableView, indexPath, journey) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyCell", for: indexPath)
            
            cell.textLabel?.text = color.name
            cell.detailTextLabel?.text = color.hexColor
            
            let backgroundColor = color.uiColor ?? .systemBackground
            cell.textLabel?.textColor = UIColor.basedOnBackgroundColor(backgroundColor)
            cell.detailTextLabel?.textColor = UIColor.basedOnBackgroundColor(backgroundColor)
            cell.contentView.backgroundColor = backgroundColor
            
            return cell
        }
        
        setupSnapshot()
    }

    private func setupSnapshot() {
        diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<JourneySection, Journey>()
        diffableDataSourceSnapshot.appendSections([JourneySection.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
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
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JourneyTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // This will be used later on
    }

}
