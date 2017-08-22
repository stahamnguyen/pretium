//
//  GearInCategoryViewController.swift
//  Pretium
//
//  Created by Staham Nguyen on 22/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class GearInCategoryController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    let padding = Create.relativeValueScaledToIphone6Plus(of: 10)
    
    private var gearFetchedResultsController = NSFetchedResultsController<Gear>()
    var category: Category
    
    init(collectionViewLayout layout: UICollectionViewLayout, category: Category) {
        self.category = category
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        collectionView?.collectionViewLayout = layout
        
        attempFetch()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(CellInGearInCategoryController.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let availableGearInCategory = gearFetchedResultsController.fetchedObjects {
            if availableGearInCategory.isEmpty {
                return 0
            } else {
                return availableGearInCategory.count
            }
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellInGearInCategoryController
        if let availableGearInCategory = gearFetchedResultsController.fetchedObjects {
            let gear = availableGearInCategory[indexPath.row]
            cell.imageView.image = gear.photo as? UIImage
            cell.nameLabel.text = gear.model
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Create.relativeValueScaledToIphone6Plus(of: 192), height: Create.relativeValueScaledToIphone6Plus(of: 227))
    }
    
    //Partly configure cell's padding (layout)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func attempFetch() {
        let fetchRequest: NSFetchRequest<Gear> = Gear.fetchRequest()
        let nameSort = NSSortDescriptor(key: "model", ascending: true)
        let predicate = NSPredicate(format: "belongToCategory = %@", category)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        gearFetchedResultsController = fetchedResultsController
        gearFetchedResultsController.delegate = self
        
        do {
            try self.gearFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
}
