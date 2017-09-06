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

private let textOfEmptyGear = "Your vault is empty. \nStart now by adding your first item."
private let textOfEmptyKit = "You currently have no kits. Let's organize your gears now by creating your first kit."
private let addGearButtonTitle = "Add Gear"
private let addKitButtonTitle = "Add Kit"

let padding = Create.relativeValueScaledToIphone6Plus(of: 9)

private var previousAmountOfCategory: Int = 0
private var complementForUnsynchronizationOfCollectionViewAndCoreData: Int = 0
private var isCategorySelected = true


class GearManagementController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private var segmentedController = UISegmentedControl()
    private var searchBar = UISearchBar()
    private var searchButton = UIBarButtonItem()
    private var addButton = UIBarButtonItem()
    private var categoryFetchedResultsController = NSFetchedResultsController<Category>()
    private var kitFetchedResultsController = NSFetchedResultsController<Kit>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isCategorySelected = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.OF_CONTRAST_ITEMS]
        
        createBarItem()
        createSegmentedControlTitleView()
        
        displayEmptyGearOrEmptyKit()
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        partlySetupLayout(withPadding: padding)
        
        collectionView?.register(CustomCellInGearManagementController.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    //  -------   SETUP UI FUNCS   --------
    
    
    //Setup view in case there is no gear
    private func createContentInCaseThereIsNoGear() {
        createContent(withNameOfImage: "safe", text: textOfEmptyGear, buttonTitle: addGearButtonTitle)
    }
    
    private func createContentInCaseThereIsNoKit() {
        createContent(withNameOfImage: "kit", text: textOfEmptyKit, buttonTitle: addKitButtonTitle)
    }
    
    private func createContent(withNameOfImage name: String, text: String, buttonTitle: String) {
        createImage(withName: name)
        createLabel(withText: text)
        createButton(withTitle: buttonTitle)
    }
    
    private func createImage(withName name: String) {
        let image = UIImageView(image: UIImage(named: name))
        image.frame = Create.frameScaledToIphone6Plus(x: 75, y: 119, width: 264, height: 264)
        collectionView?.addSubview(image)
    }
    
    private func createLabel(withText text: String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 15, forIphone6: 17, forIphone6Plus: 19))
        label.frame = Create.frameScaledToIphone6Plus(x: 27.5, y: 427, width: 359, height: 50)
        collectionView?.addSubview(label)
    }
    
    private func createButton(withTitle title: String) {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        if title == addGearButtonTitle {
            button.addTarget(self, action: #selector(pushToConfigureGearController), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(pushToConfigureKitController), for: .touchUpInside)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 20, forIphone6: 22, forIphone6Plus: 24))
        button.frame = Create.frameScaledToIphone6Plus(x: 148, y: 495, width: 118, height: 29)
        collectionView?.addSubview(button)
    }
    
    private func displayEmptyGearOrEmptyKit() {
        attempFetchCategory()
        attempFetchKit()
        
        for view in (collectionView?.subviews)! {
            view.removeFromSuperview()
        }
        
        if let availableCategories = categoryFetchedResultsController.fetchedObjects, let availableKits = kitFetchedResultsController.fetchedObjects {
            let thereIsGear = availableCategories.count != 0
            let thereIsKit = availableKits.count != 0
            
            if thereIsGear && !thereIsKit && !isCategorySelected {
                createContentInCaseThereIsNoKit()
            } else if !thereIsGear && thereIsKit && isCategorySelected {
                createContentInCaseThereIsNoGear()
            } else if !thereIsGear && !thereIsKit {
                createContentInCaseThereIsNoGear() //encourage user to create gear first
            }
        }
    }
    
    private func createBarItem() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search,
                                           target: self,
                                           action: #selector(self.search))
        self.searchButton = searchButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.add))
        self.addButton = addButton
        let buttons = [addButton, searchButton]
        navigationItem.rightBarButtonItems = buttons
    }
    
    private func createSegmentedControlTitleView() {
        let segmentedControl = UISegmentedControl(items: ["Category", "Kit"])
        segmentedControl.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: 235, height: 25)
        segmentedControl.selectedSegmentIndex = 0
        
        let fontSize = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 13, forIphone6: 15, forIphone6Plus: 17))
        segmentedControl.setTitleTextAttributes([NSFontAttributeName:fontSize], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        self.segmentedController = segmentedControl
        
        navigationItem.titleView = segmentedControl
    }
    
    
    //  -------   SETUP ACTIONS FOR BUTTONS FUNCS   --------
    
    @objc private func segmentedControlValueChanged() {
        isCategorySelected = !isCategorySelected
        collectionView?.reloadData()
        displayEmptyGearOrEmptyKit()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: isCategorySelected ? "Category" : "Kit",
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: nil,
                                                           action: nil)
    }
    
    @objc private func search() {
        let layout = UICollectionViewFlowLayout()
        let searchGearController = SearchGearController(collectionViewLayout: layout)
        navigationController?.pushViewController(searchGearController, animated: true)
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
    
    @objc private func pushToConfigureKitController() {
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
            let gearInCategoryController = GearInCategoryOrKitController(collectionViewLayout: layout, category: category, kit: nil)
            navigationController?.pushViewController(gearInCategoryController, animated: true)
        } else {
            let kit = kitFetchedResultsController.object(at: indexPath)
            let gearInKitController = GearInCategoryOrKitController(collectionViewLayout: layout, category: nil, kit: kit)
            navigationController?.pushViewController(gearInKitController, animated: true)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Create.relativeValueScaledToIphone6Plus(of: 192), height: Create.relativeValueScaledToIphone6Plus(of: 227))
    }
    
    //Partly configure cell's padding (layout)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    
    //  -------   SETUP CORE DATA FUNCS   --------
    
    
    private func attempFetchCategory() {
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
    
    private func attempFetchKit() {
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
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            displayEmptyGearOrEmptyKit()
            if (anObject is Category && isCategorySelected) || (anObject is Kit && !isCategorySelected) {
                if let indexPath = newIndexPath {
                    self.insertItems(at: indexPath)
                }
            }
        case .delete:
            if let indexPath = indexPath {
                if isCategorySelected {
                    let currentAmountOfCategory = categoryFetchedResultsController.fetchedObjects?.count ?? 0
                    if previousAmountOfCategory > currentAmountOfCategory { // Only deleting
                        complementForUnsynchronizationOfCollectionViewAndCoreData = 0
                    } else { // Deleting then preparing for inserting
                        complementForUnsynchronizationOfCollectionViewAndCoreData = -1
                    }
                    collectionView?.deleteItems(at: [indexPath])
                } else if anObject is Kit && !isCategorySelected {
                    collectionView?.deleteItems(at: [indexPath])
                }
            }
            displayEmptyGearOrEmptyKit()
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
    
    private func insertItems(at indexPath: IndexPath?) {
        if let indexPath = indexPath {
            complementForUnsynchronizationOfCollectionViewAndCoreData = 0
            collectionView?.insertItems(at: [indexPath])
        }
    }
    
    private func updateCell(at indexPath: IndexPath) {
        if let cell = collectionView?.cellForItem(at: indexPath) as? CustomCellInGearManagementController { //Make sure that the category still exists to have cell at the index path
            if isCategorySelected {
                let category = categoryFetchedResultsController.object(at: indexPath)
                if category.haveGear?.count == 1 {
                    cell.amountLabel.text = "\((category.haveGear?.count)!) item"
                } else {
                    cell.amountLabel.text = "\((category.haveGear?.count)!) items"
                }
            } else {
                let kit = kitFetchedResultsController.object(at: indexPath)
                cell.nameLabel.text = kit.name
                cell.imageView.image = kit.photo as? UIImage
                if kit.haveGear?.count == 0 {
                    cell.amountLabel.text = "No item"
                } else if kit.haveGear?.count == 1 {
                    cell.amountLabel.text = "\((kit.haveGear?.count)!) item"
                } else {
                    cell.amountLabel.text = "\((kit.haveGear?.count)!) items"
                }
            }
        }
    }
}
