//
//  SearchGearController.swift
//  Pretium
//
//  Created by Staham Nguyen on 31/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "cellId"

class SearchGearController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    private var gearFetchedResultsController = NSFetchedResultsController<Gear>()
    
    private var searchBar = UISearchBar()
    private var cancelButtonOfSearchBar = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        createSearchBar()
        
        partlySetupLayout(withPadding: padding)
        
        collectionView?.register(CustomCellInGearManagementController.self, forCellWithReuseIdentifier: cellId)
        
        attemptFetchGear(withName: "")
    }
    
    // ---   SETUP SEARCH BAR   ---
    
    private func createSearchBar() {
        let searchBar = UISearchBar()
        let textFieldOfSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        searchBar.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: 255, height: 80)
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search your vault"
        searchBar.delegate = self
        textFieldOfSearchBar?.backgroundColor = Colors.OF_TEXT_FIELD_OF_SEARCH_BAR
        textFieldOfSearchBar?.textColor = Colors.OF_BUTTON_TITLE
        self.searchBar = searchBar
        searchBar.becomeFirstResponder()
        
        navigationItem.titleView = searchBar
        navigationItem.hidesBackButton = true
    }
    
    // ---   SEARCH BAR DELEGATE   ---
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        attemptFetchGear(withName: searchText)
        gearFetchedResultsController.delegate = self
        collectionView?.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        cancelButtonOfSearchBar.isEnabled = true
    }
    
    // --- COLLECTION VIEW SETUP   ---
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let suitableGears = gearFetchedResultsController.fetchedObjects {
            return suitableGears.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellInGearManagementController
        if let suitableGears = gearFetchedResultsController.fetchedObjects {
            let suitableGear = suitableGears[indexPath.row]
            cell.type = .kitCell
            cell.nameLabel.text = suitableGear.model
            cell.imageView.image = suitableGear.photo as? UIImage ?? #imageLiteral(resourceName: "Default")
        }
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Create.relativeValueScaledToIphone6Plus(of: 192), height: Create.relativeValueScaledToIphone6Plus(of: 227))
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        let editGearController = ConfigureGearController()
        editGearController.titleOfViewController = "Edit Gear"
        editGearController.rightBarButtonTitle = "Save"
        
        if let suitableGears = gearFetchedResultsController.fetchedObjects {
            let selectedGear = suitableGears[indexPath.row]
            editGearController.isInEditingMode = true
            editGearController.editedGear = selectedGear
        }
        
        navigationController?.pushViewController(editGearController, animated: true)
    }
    
    private func attemptFetchGear(withName name: String) {
        let fetchRequest: NSFetchRequest<Gear> = Gear.fetchRequest()
        let nameSort = NSSortDescriptor(key: "model", ascending: true)
        let predicate = NSPredicate(format: "model CONTAINS %@", name)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.gearFetchedResultsController = controller
        
        do {
            try self.gearFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
                cell.imageView.image = gear.photo as? UIImage ?? #imageLiteral(resourceName: "Default")
                cell.nameLabel.text = gear.model
            }
        case .move:
            return
        }
    }
}
