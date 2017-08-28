//
//  GearManagementScreenViewController.swift
//  Pretium
//
//  Created by Staham Nguyen on 31/07/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "cellId"

private let messageOfAddNewStuffMenu = "What would you like to add?"
private let titleOfAddNewStuffMenu = ["New Gear", "New Kit", "Cancel"]

private let textOfEmptyVault = "Your vault is empty. \nStart now by adding your first item."
private let addGearButtonTitle = "Add Gear"

private let padding = Create.relativeValueScaledToIphone6Plus(of: 10)

private var previousAmountOfCategory: Int = 0
private var complementForUnsynchronizationOfCollectionViewAndCoreData: Int = 0
private var isCategorySelected = true


class GearManagementController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private var background = UIView()
    private var segmentedController = UISegmentedControl()
    private var categoryFetchedResultsController = NSFetchedResultsController<Category>()
    private var kitFetchedResultsController = NSFetchedResultsController<Kit>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isCategorySelected = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.OF_CONTRAST_ITEMS]
        
        createSegmentedControl(withItems: "Categories", "Kits")
        createAddButtonAndSearchButton()
        
//        createContentInCaseThereIsNoGear()
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        partlySetupLayout(withPadding: padding)
        
        collectionView?.register(CustomCellInGearManagementController.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    //  -------   SETUP UI FUNCS   --------
    
    
    //Setup view in case there is no gear
    func createContentInCaseThereIsNoGear() {
        createBackground()
        createContent()
    }
    
    private func createBackground() {
        let background = UIView()
        background.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: Screen.WIDTH_OF_IPHONE_6PLUS, height: Screen.HEIGHT_OF_IPHONE_6PLUS)
        background.backgroundColor = UIColor.white
        collectionView?.addSubview(background)
        self.background = background
    }
    
    private func createContent() {
        createVaultImage()
        createLabel()
        createAddGearButton()
    }
    
    private func createVaultImage() {
        let emptyVaultImage = UIImageView(image: UIImage(named: "safe"))
        emptyVaultImage.frame = Create.frameScaledToIphone6Plus(x: 118, y: 205, width: 178, height: 178)
        self.background.addSubview(emptyVaultImage)
    }
    
    private func createLabel() {
        let emptyVaultLabel = UILabel()
        emptyVaultLabel.text = textOfEmptyVault
        emptyVaultLabel.textAlignment = .center
        emptyVaultLabel.numberOfLines = 2
        emptyVaultLabel.textColor = .lightGray
        emptyVaultLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 15, forIphone6: 17, forIphone6Plus: 19))
        emptyVaultLabel.frame = Create.frameScaledToIphone6Plus(x: 27.5, y: 427, width: 359, height: 50)
        self.background.addSubview(emptyVaultLabel)
    }
    
    private func createAddGearButton() {
        let addGearButton = UIButton()
        addGearButton.titleLabel?.textAlignment = .center
        addGearButton.setTitle(addGearButtonTitle, for: .normal)
        addGearButton.setTitleColor(.blue, for: .normal)
        addGearButton.addTarget(self, action: #selector(pushToConfigureGearController), for: .touchUpInside)
        addGearButton.titleLabel?.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 20, forIphone6: 22, forIphone6Plus: 24))
        addGearButton.frame = Create.frameScaledToIphone6Plus(x: 148, y: 495, width: 118, height: 29)
        self.background.addSubview(addGearButton)
    }
    
    private func createSegmentedControl(withItems items: String...) {
        let segmentedController = UISegmentedControl(items: items)
        segmentedController.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: 205, height: 25)
        segmentedController.selectedSegmentIndex = 0
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentedController)
        
        segmentedController.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        self.segmentedController = segmentedController
    }
    
    private func createAddButtonAndSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search,
                                           target: self,
                                           action: #selector(self.search))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.add))
        let buttons = [addButton, searchButton]
        navigationItem.rightBarButtonItems = buttons
    }
    
    
    //  -------   SETUP ACTIONS FOR BUTTONS FUNCS   --------
    
    @objc private func segmentedControlValueChanged() {
        isCategorySelected = !isCategorySelected
        collectionView?.reloadData()
    }
    
    @objc private func search() {
    }
    
    @objc private func add() {
        let actionSheet = UIAlertController(title: nil,
                                            message: messageOfAddNewStuffMenu,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: titleOfAddNewStuffMenu[0],
                                            style: .default,
                                            handler: { action in self.pushToConfigureGearController() }))
        actionSheet.addAction(UIAlertAction(title: titleOfAddNewStuffMenu[1],
                                            style: .default,
                                            handler: { action in self.pushToConfigureKitController() }))
        actionSheet.addAction(UIAlertAction(title: titleOfAddNewStuffMenu[2],
                                            style: .cancel,
                                            handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func pushToConfigureGearController() {
        let configureGearController = ConfigureGearController()
        navigationController?.pushViewController(configureGearController, animated: true)
    }
    
    private func pushToConfigureKitController() {
        let layout = UICollectionViewFlowLayout()
        let configureKitController = ConfigureKitController(collectionViewLayout: layout)
        navigationController?.pushViewController(configureKitController, animated: true)
    }
    
    
    //  -------   SETUP COLLECTION VIEW FUNCS   --------
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCategorySelected {
            attempFetchCategory()
            if let availableCategories = categoryFetchedResultsController.fetchedObjects {
                let amountOfAvailableCategories = availableCategories.count + complementForUnsynchronizationOfCollectionViewAndCoreData
                return amountOfAvailableCategories
            }
            return 0
        } else {
            attempFetchKit()
            if let availableKits = kitFetchedResultsController.fetchedObjects {
                let amountOfAvailableKits = availableKits.count
                return amountOfAvailableKits
            }
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellInGearManagementController
        
        if isCategorySelected {
            let category = categoryFetchedResultsController.object(at: indexPath)
            cell.nameLabel.text = category.name
            cell.imageView.image = UIImage(named: "\(category.name!)")
            cell.type = .categoryCell
            
            if category.haveGear?.count == 1 {
                cell.amountLabel.text = "\((category.haveGear?.count)!) item"
            } else {
                cell.amountLabel.text = "\((category.haveGear?.count)!) items"
            }
        }
        
        else {
            let kit = kitFetchedResultsController.object(at: indexPath)
            cell.nameLabel.text = kit.name
            cell.imageView.image = kit.photo as? UIImage
            cell.type = .kitCell
            
            if kit.haveGear?.count == 0 {
                cell.amountLabel.text = "No item"
            } else if kit.haveGear?.count == 1 {
                cell.amountLabel.text = "\((kit.haveGear?.count)!) item"
            } else {
                cell.amountLabel.text = "\((kit.haveGear?.count)!) items"
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        if isCategorySelected {
            let category = categoryFetchedResultsController.object(at: indexPath)
            let gearInCategoryController = GearInCategoryController(collectionViewLayout: layout, category: category)
            navigationController?.pushViewController(gearInCategoryController, animated: true)
        } else {
            let kit = kitFetchedResultsController.object(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Create.relativeValueScaledToIphone6Plus(of: 192), height: Create.relativeValueScaledToIphone6Plus(of: 227))
    }
    
    //Partly configure cell's padding (layout)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    
    //  -------   SETUP CORE DATA FUNCS   --------
    
    
    func attempFetchCategory() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        categoryFetchedResultsController = fetchedResultsController
        categoryFetchedResultsController.delegate = self
        
        do {
            try self.categoryFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        previousAmountOfCategory = categoryFetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func attempFetchKit() {
        let fetchRequest: NSFetchRequest<Kit> = Kit.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        kitFetchedResultsController = fetchedResultsController
        kitFetchedResultsController.delegate = self
        
        do {
            try self.kitFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // Listen to changes from Core Data to update Collection View
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                complementForUnsynchronizationOfCollectionViewAndCoreData = 0
                collectionView?.insertItems(at: [indexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                let currentAmountOfCategory = categoryFetchedResultsController.fetchedObjects?.count ?? 0
                if previousAmountOfCategory > currentAmountOfCategory { // Only deleting
                    complementForUnsynchronizationOfCollectionViewAndCoreData = 0
                } else { // Deleting then preparing for inserting
                    complementForUnsynchronizationOfCollectionViewAndCoreData = -1
                }
                collectionView?.deleteItems(at: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                updateCell(at: indexPath)
            }
            if let indexPath = newIndexPath { // In case the update add more category
                updateCell(at: indexPath)
            }
        case .move:
            return
        }
    }
    
    func updateCell(at indexPath: IndexPath) {
        if let cell = collectionView?.cellForItem(at: indexPath) as? CustomCellInGearManagementController { //Make sure that the category still exist to have cell at the index path
            let category = categoryFetchedResultsController.object(at: indexPath)
            if category.haveGear?.count == 1 {
                cell.amountLabel.text = "\((category.haveGear?.count)!) item"
            } else {
                cell.amountLabel.text = "\((category.haveGear?.count)!) items"
            }
        }
    }
}
