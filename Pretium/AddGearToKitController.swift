//
//  AddGearToKitController.swift
//  Pretium
//
//  Created by Staham Nguyen on 27/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"
private let nameOfDefaultCoverImage = "Default"
private let titleOfRightBarButton = "Done"

private let padding = Create.relativeValueScaledToIphone6Plus(of: 10)

class AddGearToKitController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var gearFetchedResultsController = NSFetchedResultsController<Gear>()
    var nameOfKit = ""
    var image = UIImage()
    private var selectedGears = [Int:Gear]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(title: titleOfRightBarButton,
                                             style: UIBarButtonItemStyle.plain,
                                             target: self,
                                             action: #selector(completeAddingGearToKit))
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationItem.title = "Add Gear"
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        partlySetupLayout(withPadding: padding)

        attempFetch()

        // Register cell classes
        self.collectionView!.register(CustomCellInGearManagementController.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // ---   COLLECTION VIEW SETUP   ---
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let availableGear = gearFetchedResultsController.fetchedObjects {
            return availableGear.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCellInGearManagementController
        if let availableGear = gearFetchedResultsController.fetchedObjects {
            let gear = availableGear[indexPath.row]
            cell.nameLabel.text = gear.model
            cell.imageView.image = gear.photo as? UIImage ?? UIImage(named: nameOfDefaultCoverImage)
            cell.checkMarkView.isHidden = false
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellInGearManagementController
        cell.checkMarkView.checked = !cell.checkMarkView.checked
        cell.layer.borderWidth = cell.checkMarkView.checked ? 2 : 0.5
        cell.layer.borderColor = cell.checkMarkView.checked ? UIColor.blue.cgColor : UIColor.black.cgColor
        
        if let availableGear = gearFetchedResultsController.fetchedObjects {
            let gear = availableGear[indexPath.row]
            if cell.checkMarkView.checked {
                selectedGears[indexPath.row] = gear
            } else {
                selectedGears.removeValue(forKey: indexPath.row)
            }
        }
    }
    
    // ---   SETUP BUTTON'S FUNC   ---
    
    @objc private func completeAddingGearToKit() {
        let kit = NSEntityDescription.insertNewObject(forEntityName: "Kit", into: context) as! Kit
        
        kit.photo = self.image
        kit.name = self.nameOfKit
        
        for selectedGear in self.selectedGears.values {
            kit.addToHaveGear(selectedGear)
            selectedGear.addToBelongToKit(kit)
        }
        
        AppDelegate.saveContext()
        
        navigationController?.popToViewController(Current.GEAR_MANAGEMENT_CONTROLLER, animated: true)
    }
    
    // ---   CORE DATA FUNCS   ---
    
    private func attempFetch() {
        let fetchRequest: NSFetchRequest<Gear> = Gear.fetchRequest()
        let nameSort = NSSortDescriptor(key: "model", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.gearFetchedResultsController = fetchedResultsController
        
        do {
            try self.gearFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
}
