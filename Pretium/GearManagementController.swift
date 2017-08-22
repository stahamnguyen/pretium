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

class GearManagementController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let messageOfAddNewStuffMenu = "What would you like to add?"
    private let titleOfAddNewStuffMenu = ["New Gear", "New Kit", "Cancel"]
    
    private let textOfEmptyVault = "Your vault is empty. \nStart now by adding your first item."
    private let addGearButtonTitle = "Add Gear"
    private var background = UIView()
    
    let padding = Create.relativeValueScaledToIphone6Plus(of: 10)
    
    private var categoryFetchedResultsController = NSFetchedResultsController<Category>()
    private var kitFetchedResultsController = NSFetchedResultsController<Kit>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSegmentedControl(withItems: "Kits", "Categories")
        createAddButtonAndSearchButton()
        
//        createContentInCaseThereIsNoGear()
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        collectionView?.collectionViewLayout = layout
        
        collectionView?.register(CustomCellInGearManagementController.self, forCellWithReuseIdentifier: cellId)
        
        attempFetch()
    }
    
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
        addGearButton.addTarget(self, action: #selector(pushToAddGearController), for: .touchUpInside)
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
    
    @objc private func search() {
        
    }
    
    @objc private func add() {
        let actionSheet = UIAlertController(title: nil,
                                            message: messageOfAddNewStuffMenu,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: titleOfAddNewStuffMenu[0],
                                            style: .default,
                                            handler: { action in self.pushToAddGearController()}))
        actionSheet.addAction(UIAlertAction(title: titleOfAddNewStuffMenu[1],
                                            style: .default,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: titleOfAddNewStuffMenu[2],
                                            style: .cancel,
                                            handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func pushToAddGearController() {
        let addGearController = AddGearController()
        navigationController?.pushViewController(addGearController, animated: true)
    }
    
    //Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categories = categoryFetchedResultsController.sections?[section] {
            return categories.numberOfObjects
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellInGearManagementController
        let category = categoryFetchedResultsController.object(at: indexPath)
        cell.nameLabel.text = category.name
        cell.imageView.image = UIImage(named: "\(category.name!)")
        cell.amountLabel.text = "\((category.haveGear?.count)!) item(s)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let category = categoryFetchedResultsController.object(at: indexPath)
        let gearInCategoryController = GearInCategoryController(collectionViewLayout: layout, category: category)
        navigationController?.pushViewController(gearInCategoryController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Create.relativeValueScaledToIphone6Plus(of: 192), height: Create.relativeValueScaledToIphone6Plus(of: 227))
    }
    
    //Partly configure cell's padding (layout)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    //Core Data
    func attempFetch() {
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
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView?.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView?.insertItems(at: [newIndexPath!])
        case .update:
            let cell = collectionView?.cellForItem(at: indexPath!) as! CustomCellInGearManagementController
            let category = categoryFetchedResultsController.object(at: indexPath!)
            cell.amountLabel.text = "\((category.haveGear?.count)!) item(s)"
        case .move:
            return
        }
    }
}
