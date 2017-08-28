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
private let nameOfDefaultCoverImage = "Default"

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
        
        navigationItem.title = category.name
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.OF_CONTRAST_ITEMS]
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        partlySetupLayout(withPadding: padding)
        
        //Fetch data from database
        attempFetch()

        // Register cell classes
        self.collectionView!.register(CustomCellInGearManagementController.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // ---   COLLECTION VIEW SETUP   ---
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let availableGearInCategory = gearFetchedResultsController.fetchedObjects {
            if availableGearInCategory.isEmpty {
                navigationController?.popViewController(animated: true)
                return 0
            } else {
                return availableGearInCategory.count
            }
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCellInGearManagementController
        if let availableGearInCategory = gearFetchedResultsController.fetchedObjects {
            let gear = availableGearInCategory[indexPath.row]
            cell.imageView.image = gear.photo as? UIImage ?? UIImage(named: nameOfDefaultCoverImage)
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
    
    //Push to edit gear controller when touch on gear cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editGearController = ConfigureGearController()
        editGearController.titleOfViewController = "Edit Gear"
        editGearController.rightBarButtonTitle = "Save"
        
        if let availableGearInCategory = gearFetchedResultsController.fetchedObjects {
            let selectedGear = availableGearInCategory[indexPath.row]
            editGearController.isInEditingMode = true
            editGearController.editedGear = selectedGear
        }
        
        navigationController?.pushViewController(editGearController, animated: true)
    }
    
    // ---   CORE DATA FUNCS   ---
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                collectionView?.insertItems(at: [indexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                collectionView?.deleteItems(at: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                let cell = collectionView?.cellForItem(at: indexPath) as! CustomCellInGearManagementController
                let gear = gearFetchedResultsController.object(at: indexPath)
                cell.imageView.image = gear.photo as? UIImage
                cell.nameLabel.text = gear.model
            }
        case .move:
            return
        }
    }
}
