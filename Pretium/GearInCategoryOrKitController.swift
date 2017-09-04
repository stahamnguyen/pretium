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
private let titleOfConfigureGearControllerBackBarButton = "Back"
private let titleOfConfigureKitActionSheetSelections = ["Add Gear To Kit", "Edit Kit", "Delete Kit", "Cancel"]
private let titleOfKitDeletingConfirmation = "Do you really want to delete this kit?"
private let messageOfKitDeletingConfirmation = "Item will stay in your vault."
private let titleOfKitDeletingConfirmationSelections = ["Yes, Delete This Kit", "Cancel"]

private var complementForUnsynchronizationBetweenCollectionViewAndCoreData: Int = 0

class GearInCategoryOrKitController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private var gearFetchedResultsController = NSFetchedResultsController<Gear>()
    var category: Category?
    var kit: Kit?
    
    init(collectionViewLayout layout: UICollectionViewLayout, category: Category?, kit: Kit?) {
        self.category = category
        self.kit = kit
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = (category != nil) ? category?.name : kit?.name
        
        //Set title for the back bar button of Configure Gear Controller
        navigationItem.backBarButtonItem = UIBarButtonItem(title: titleOfConfigureGearControllerBackBarButton,
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: nil,
                                                           action: nil)
        
        if kit != nil {
            setupConfigureKitButton()
        }
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        partlySetupLayout(withPadding: padding)
        
        //Fetch data from database
        attempFetch()

        // Register cell classes
        self.collectionView!.register(CustomCellInGearManagementController.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // ---   UI SETUP FUNCS   ---
    private func setupConfigureKitButton() {
        let configureButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                        target: self,
                                        action: #selector(showConfigureKitActionSheet))
        navigationItem.rightBarButtonItems = [configureButton]
    }
    
    // ---   SETUP BUTTONS' FUNCS   ---
    @objc private func showConfigureKitActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: titleOfConfigureKitActionSheetSelections[0],
                                            style: .default,
                                            handler: { action in self.pushToAddGearToKitController() }))
        actionSheet.addAction(UIAlertAction(title: titleOfConfigureKitActionSheetSelections[1],
                                            style: .default,
                                            handler: { action in self.pushToNameOfKitController() }))
        actionSheet.addAction(UIAlertAction(title: titleOfConfigureKitActionSheetSelections[2],
                                            style: .destructive,
                                            handler: { action in self.showKitDeletingConformationActionSheet() }))
        actionSheet.addAction(UIAlertAction(title: titleOfConfigureKitActionSheetSelections[3],
                                            style: .cancel,
                                            handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func pushToAddGearToKitController() {
        let layout = UICollectionViewFlowLayout()
        let addGearToKitController = AddGearToKitController(collectionViewLayout: layout)
        addGearToKitController.editedKit = kit
        addGearToKitController.isInEditingMode = true
        navigationController?.pushViewController(addGearToKitController, animated: true)
    }
    
    private func pushToNameOfKitController() {
        let nameOfKitController = NameKitController()
        nameOfKitController.isEdited = true
        nameOfKitController.originalNameOfKit = (kit?.name)!
        nameOfKitController.image = kit?.photo as! UIImage
        nameOfKitController.editedKit = kit
        nameOfKitController.previousGearInKitControllerIfInEditingMode = self
        navigationController?.pushViewController(nameOfKitController, animated: true)
    }
    
    private func showKitDeletingConformationActionSheet() {
        let actionSheet = UIAlertController(title: titleOfKitDeletingConfirmation,
                                            message: messageOfKitDeletingConfirmation,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: titleOfKitDeletingConfirmationSelections[0],
                                            style: .destructive,
                                            handler: { action in self.deleteKit() }))
        actionSheet.addAction(UIAlertAction(title: titleOfKitDeletingConfirmationSelections[1],
                                            style: .cancel,
                                            handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func deleteKit() {
        // Remove all relationship of gears to the kit
        gearFetchedResultsController.fetchedObjects?.forEach({ gear in
            gear.removeFromBelongToKit(kit!)
            kit?.removeFromHaveGear(gear)
            AppDelegate.saveContext()
        })
        
        // Delete the kit
        context.delete(kit!)
        AppDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    // ---   COLLECTION VIEW SETUP   ---
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let availableGearInCategoryOrKit = gearFetchedResultsController.fetchedObjects {
            if availableGearInCategoryOrKit.isEmpty {
                if kit == nil {
                    navigationController?.popViewController(animated: true)
                }
                return 0
            } else {
                return availableGearInCategoryOrKit.count + complementForUnsynchronizationBetweenCollectionViewAndCoreData
            }
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCellInGearManagementController
        if let availableGearInCategory = gearFetchedResultsController.fetchedObjects {
            let gear = availableGearInCategory[indexPath.row]
            cell.type = .kitCell
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
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.predicate = (category != nil) ? NSPredicate(format: "belongToCategory = %@", category!) : NSPredicate(format: "ANY belongToKit = %@", kit!)
        
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
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                collectionView?.insertItems(at: [indexPath])
            }
        case .delete:
            if anObject is Gear {
                if let indexPath = indexPath {
                    collectionView?.deleteItems(at: [indexPath])
                }
            }
        case .update:
            if let indexPath = indexPath {
                let cell = collectionView?.cellForItem(at: indexPath) as! CustomCellInGearManagementController
                let gear = gearFetchedResultsController.object(at: indexPath)
                cell.imageView.image = gear.photo as? UIImage ?? UIImage(named: nameOfDefaultCoverImage)
                cell.nameLabel.text = gear.model
            }
        case .move:
            return
        }
    }
}
