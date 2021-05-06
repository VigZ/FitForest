//
//  RunyunCollectionViewController.swift
//  FitForest
//
//  Created by Kyle Vigorito on 5/5/21.
//

import Foundation
import UIKit

private let reuseIdentifier = "RunyunCard"

class RunyunCollectionViewController: UICollectionViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
       

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(RunyunCard.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.itemSize = CGSize(width: self.collectionView.bounds.width, height: 120)
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameData.sharedInstance.inventory.runyunStorage.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RunyunCard
        let runyun = GameData.sharedInstance.inventory.runyunStorage[indexPath.row]
        
//        cell.nameLabel.text = item.name        // Configure the cell
        cell.runyun = runyun
        cell.backgroundColor = .systemGreen
        let recognizer = UILongPressGestureRecognizer(target: cell, action: #selector(cell.createNode(_:)))
        cell.addGestureRecognizer(recognizer)
        return cell
    }


    // MARK: UICollectionViewDelegate

    

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }

}
