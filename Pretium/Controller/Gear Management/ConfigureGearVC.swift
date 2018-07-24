//
//  AddGearController.swift
//  Pretium
//
//  Created by Staham Nguyen on 07/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

// ---   CONSTANT DECLARATION   ---

private let titleForBackButtonOfAddKitsForGearController = "Gear"

private let cellOfManufacturerAndModel = "1"
private let cellOfCategory = "2"
private let cellOfSerialNumber = "3"
private let cellOfPrice = "4"
private let cellOfUsed = "5"
private let cellOfDateOfPurchase = "6"
private let cellOfAddToKit = "7"
private let cellOfNote = "8"
private let cellOfDelete = "9"

private let sectionTitle = ["", "", "PURCHASE INFORMATION", "ASSIGNED KITS", "NOTES", ""]

private var titleOfCell: [[String]] {
    let titleOfCellInSectionTwo = ["Category", "Serial No."]
    let titleOfCellInSectionThree = ["Price", "Used", "Date of Purchase"]
    let titleOfCellInSectionFour = ["Add to kit"]
    let titleOfCellInSectionSix = ["Delete"]
    return [titleOfCellInSectionTwo, titleOfCellInSectionThree, titleOfCellInSectionFour, titleOfCellInSectionSix]
}

private let defaultSerialNumberPlaceholder = "000 000 000"

// These titles and message are also used in NameOfKitController
let titleOfPhotoPickerMenu = ["Take a photo", "Choose from library", "Delete", "Cancel"]
let titleOfNoCameraAlert = "No Camera"
let messageOfNoCameraAlert = "Sorry, this device has no camera"
let okSelectionTitle = "OK"

private let messageOfAskForDeleteGearConfirmation = "Do you really want to delete this gear?"
private let titleOfDeleteGearConfirmation = ["Yes, delete this gear", "Cancel"]

// ---   RUNNING CODE   ---

class ConfigureGearController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, SendAndReceiveDataDelegate {
    
    var titleOfViewController = "New Gear"
    
    var rightBarButtonTitle = "Add"
    
    private var indexPathArray = [IndexPath]()
    private var assignedKits = [Kit]()
    private var assignedKitsSortedAlphabetically = [Kit]()
    private var unassignedKits = [Kit]()
    
    var isInEditingMode = false
    var editedGear: Gear? = nil
    var numberOfKitHavingGear = 0
    
    private var complementSectionForDeleteGearButton: Int = 0
    
    var manufacturerTextField = CustomPaddingTextField()
    var modelTextField = CustomPaddingTextField()
    var priceTextField = CustomPaddingTextField()
    var serialNumberTextField = CustomPaddingTextField()
    var usedSwitch = UISwitch()
    var dateOfPurchaseTextField = CustomPaddingTextField()
    var noteTextView = UITextView()
    var addGearButton = UIBarButtonItem()
    
    var addPhotoButton = UIButton()
    var photoOfItemView = UIImageView()
    var categoryStatus = UILabel()
    private let imagePicker = UIImagePickerController()
    
    private var categoryFetchedResultsController = NSFetchedResultsController<Category>()
    private var linkedKitsFetchedResultsController = NSFetchedResultsController<Kit>()
    private var unlinkedKitsFetchedResultsController = NSFetchedResultsController<Kit>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup title for "Back" button of the AddKitsForGearController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: titleForBackButtonOfAddKitsForGearController, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        //Setup title of the view controller and create "Add" button
        navigationItem.title = titleOfViewController
        let addGearButton = UIBarButtonItem(title: rightBarButtonTitle,
                                            style: .done,
                                            target: self,
                                            action: #selector(completeConfiguringItem))
        navigationItem.rightBarButtonItem = addGearButton
        self.addGearButton = addGearButton
        
        attemptFetchUnlinkedKits()
        if let unlinkedKits = unlinkedKitsFetchedResultsController.fetchedObjects {
            unlinkedKits.forEach({ kit in
                unassignedKits.append(kit)
            })
        }

        if !isInEditingMode {
            disableAddGearButtonIfModelTextFieldIsEmpty()
        } else {
            attemptFetchLinkedKits()
            if let kitsHavingGear = linkedKitsFetchedResultsController.fetchedObjects {
                kitsHavingGear.forEach({ kit in
                    assignedKits.append(kit)
                })
            }
            assignedKitsSortedAlphabetically = assignedKits.sorted(by: { $0.name! < $1.name! })
        }
        
        imagePicker.delegate = self
        
        hideKeyboardWhenTappingAround()
        
        //Register cell ID
        let cellIdArray = [cellOfManufacturerAndModel, cellOfCategory, cellOfSerialNumber, cellOfPrice, cellOfUsed, cellOfDateOfPurchase, cellOfAddToKit, cellOfNote, cellOfDelete]
        cellIdArray.forEach({ cellId in
            tableView.register(CellInConfigureGearController.self, forCellReuseIdentifier: cellId)
        })
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.backgroundColor = Colors.OF_GRAY_BACKGROUND
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Add action for buttons
        addPhotoButton.addTarget(self, action: #selector(showPhotoPickerMenu), for: .touchUpInside)
        modelTextField.addTarget(self, action: #selector(disableAddGearButtonIfModelTextFieldIsEmpty), for: .editingChanged)
        addTapGestureForImageView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // ---   SETUP TABLE VIEW   ---
    
    //Basic UITableView setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !isInEditingMode {
            complementSectionForDeleteGearButton = 1
        }
        return sectionTitle.count - complementSectionForDeleteGearButton
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return titleOfCell[0].count
        case 2:
            return titleOfCell[1].count
        case 3:
            return assignedKits.count + 1
        default:
            return 1
        }
    }
    
    //Setup cells for sections
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        //Section 1 - "Manufacturer and model" cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOfManufacturerAndModel, for: indexPath) as! CellInConfigureGearController
            //Check if the cell has been reused yet not to setup more overlapping textfields
            if (!indexPathArray.contains(indexPath)) {
                indexPathArray.append(indexPath)
                cell.type = .manufacturerAndModelCell
                
                cell.manufacturerTextField.returnKeyType = .done
                cell.modelTextField.returnKeyType = .done
                
                self.manufacturerTextField = cell.manufacturerTextField
                self.modelTextField = cell.modelTextField
                self.addPhotoButton = cell.addPhotoButton
                self.photoOfItemView = cell.photoOfItemView
                self.manufacturerTextField.delegate = self
                self.modelTextField.delegate = self
                
                if isInEditingMode{
                    self.manufacturerTextField.text = editedGear?.manufacturer
                    self.modelTextField.text = editedGear?.model
                    self.photoOfItemView.image = editedGear?.photo as? UIImage //Set image for imageView
                    
                    if photoOfItemView.image != nil {
                        photoOfItemView.alpha = 1 //Make imageView appear
                        addPhotoButton.alpha = 0 //Hide "Add photo" button
                    }
                }
            }
            return cell
        
        //Section 5 - "Note" cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOfNote, for: indexPath) as! CellInConfigureGearController
            //Check if the cell has been reused yet not to setup more overlapping textviews
            if (!indexPathArray.contains(indexPath)) {
                indexPathArray.append(indexPath)
                cell.type = .noteCell
                self.noteTextView = cell.noteTextView
                
                if isInEditingMode {
                    noteTextView.text = editedGear?.note
                }
            }
            return cell
        
        //Section 4 - "Add to Kits" cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOfAddToKit, for: indexPath) as! CellInConfigureGearController
            cell.type = .baseCell
            
            switch indexPath.row {
            case assignedKits.count: // Last row in the section, which means "Add to Kit" row
                cell.mainLabel.text = titleOfCell[indexPath.section - 1][0]
                cell.mainLabel.textColor = .blue
                cell.accessoryType = .disclosureIndicator
            default:
                let assignedKit = assignedKitsSortedAlphabetically[indexPath.row]
                cell.mainLabel.text = assignedKit.name
                cell.mainLabel.textColor = .black
                cell.accessoryType = .none
                cell.selectionStyle = .none
            }
            
            return cell
        
        //Section 2 - "Category" and "Serial Number" cells
        case 1:
            switch indexPath.row {
                
            // "Category" cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfCategory, for: indexPath) as! CellInConfigureGearController
                cell.type = .categoryCell
                cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                self.categoryStatus = cell.statusLabel
                
                if isInEditingMode {
                    self.categoryStatus.text = editedGear?.belongToCategory?.name
                }
                return cell
                
            // "Serial Number" cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfSerialNumber, for: indexPath) as! CellInConfigureGearController
                if (!indexPathArray.contains(indexPath)) {
                    indexPathArray.append(indexPath)
                    cell.type = .cellWithTextFieldInTheRight
                    cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                    cell.statusTextField.placeholder = defaultSerialNumberPlaceholder
                    cell.statusTextField.keyboardType = .numberPad
                    self.serialNumberTextField = cell.statusTextField
                    
                    if isInEditingMode {
                        serialNumberTextField.text = editedGear?.serialNumber
                    }
                }
                return cell
            }
            
        //Section 6 - "Delete" cell (only available in Editing Mode)
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOfDelete, for: indexPath) as! CellInConfigureGearController
            cell.type = .baseCell
            cell.mainLabel.text = titleOfCell[indexPath.section - 2][indexPath.row]
            cell.mainLabel.textColor = .red
            cell.mainLabel.textAlignment = .center
            cell.mainLabel.frame.origin = cell.bounds.origin
            cell.mainLabel.center = cell.convert(cell.center, from: cell.superview)
            cell.layer.borderWidth = 0.2
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        
        //Other section (Section 3) - "Price", "Used" and "Date of Purchase" cells
        default:
            switch indexPath.row {
            //"Price" cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfPrice, for: indexPath) as! CellInConfigureGearController
                //Check if the cell has been reused yet not to setup more overlapping textviews
                if (!indexPathArray.contains(indexPath)) {
                    indexPathArray.append(indexPath)
                    cell.type = .cellWithTextFieldInTheRight
                    cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                    
                    cell.statusTextField.type = .priceSetter
                    self.priceTextField = cell.statusTextField
                    
                    if isInEditingMode {
                        self.priceTextField.text = editedGear?.price
                    }
                }
                return cell
             
            //"Used" cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfUsed, for: indexPath) as! CellInConfigureGearController
                cell.type = .cellWithSwitcher
                cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.item]
                self.usedSwitch = cell.usedSwitch
                
                if isInEditingMode {
                    self.usedSwitch.isOn = (editedGear?.used)!
                }
                return cell
            
            //"Date of Purchase" cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfDateOfPurchase, for: indexPath) as! CellInConfigureGearController
                if (!indexPathArray.contains(indexPath)) {
                    indexPathArray.append(indexPath)
                    cell.type = .cellWithTextFieldInTheRight
                    cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                    cell.statusTextField.type = .datePicker
                    self.dateOfPurchaseTextField = cell.statusTextField
                    
                    if isInEditingMode {
                        self.dateOfPurchaseTextField.text = editedGear?.dateOfPurchase
                    }
                }
                return cell
            }
        }
    }
    
    //Setup custom section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Colors.OF_GRAY_BACKGROUND
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.cgColor
        
        let headerLabel = UILabel(frame: Create.frameScaledToIphone6Plus(x: 23, y: 20, width: tableView.bounds.width / Screen.RATIO_WITH_IPHONE_6PLUS, height: 0))
        headerLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 13, forIphone6: 15, forIphone6Plus: 17), weight: UIFont.Weight.thin)
        headerLabel.textColor = .black
        headerLabel.text = sectionTitle[section]
        headerLabel.sizeToFit()
        view.addSubview(headerLabel)
        
        return view
    }
    
    //Setup custom section header (for "Delete" button in Editing Mode only)
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Create.relativeValueScaledToIphone6Plus(of: 45)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Colors.OF_GRAY_BACKGROUND
        return view
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 5) {
            return Create.relativeValueScaledToIphone6Plus(of: 35)
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return Create.relativeValueScaledToIphone6Plus(of: 112)
        } else if (indexPath.section == 4) {
            return Create.relativeValueScaledToIphone6Plus(of: 190)
        } else {
            return Create.relativeValueScaledToIphone6Plus(of: 56)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
        //"Category" cell
        case 1:
            let categorySelectionViewController = CategorySelectionViewController()
            categorySelectionViewController.delegate = self
            categorySelectionViewController.currentSelection = categoryStatus.text!
            navigationController?.pushViewController(categorySelectionViewController, animated: true)
            
        //"Add to Kit" cell
        case 3:
            if indexPath.row == assignedKits.count { //Last row in the section, which means the "Add to Kit" row
                let addKitsForGearController = AddKitsForGearController()
                addKitsForGearController.editedGear = self.editedGear
                addKitsForGearController.isInEditingMode = self.isInEditingMode
                addKitsForGearController.delegate = self
                addKitsForGearController.assignedKits = self.assignedKits
                addKitsForGearController.unassignedKits = self.unassignedKits
                navigationController?.pushViewController(addKitsForGearController, animated: true)
            }
        
        //"Delete" cell (in Editing Mode only)
        case 5:
            alertOfDeleteGearConfirmation(forCellAtIndexPath: indexPath)
            
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 3 && indexPath.row != assignedKits.count {
            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            unassignedKits.append(assignedKitsSortedAlphabetically[indexPath.row])
            assignedKitsSortedAlphabetically.remove(at: indexPath.row)
            assignedKits = assignedKitsSortedAlphabetically
            tableView.reloadData()
        }
    }
    
    //Text field configuration
    @objc private func disableAddGearButtonIfModelTextFieldIsEmpty(){
        if (self.modelTextField.text ?? "").isEmpty {
            addGearButton.isEnabled = false
        } else {
            addGearButton.isEnabled = true
        }
    }
    
    // ---   SETUP BUTTON FUNCS   ---
    
    //Add tap gesture for the image view
    private func addTapGestureForImageView() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showPhotoPickerMenu))
        singleTap.numberOfTapsRequired = 1
        photoOfItemView.isUserInteractionEnabled = true
        photoOfItemView.addGestureRecognizer(singleTap)
    }
    
    //Image picker setup
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Display chosen image
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoOfItemView.image = chosenImage
            photoOfItemView.alpha = 1
            addPhotoButton.alpha = 0
        } else {
            photoOfItemView.image = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Setup Photo Picker action sheet
    @objc private func showPhotoPickerMenu() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: titleOfPhotoPickerMenu[0],
                                            style: .default,
                                            handler: { action in self.takeAPhoto()}))
        actionSheet.addAction(UIAlertAction(title: titleOfPhotoPickerMenu[1],
                                            style: .default,
                                            handler: { action in self.choosePhotoFromLibrary()}))
        
        //Check if imageView has image or not, then decide if adding "Delete" selection or not
        if photoOfItemView.image != nil {
            actionSheet.addAction(UIAlertAction(title: titleOfPhotoPickerMenu[2],
                                                style: .destructive,
                                                handler: {action in self.deleteCurrentImage()}))
        }
        actionSheet.addAction(UIAlertAction(title: titleOfPhotoPickerMenu[3],
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    //Action of "Take a photo" selection
    private func takeAPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        } else {
            alertThatThereIsNoCamera()
        }
    }
    
    //Action of "Choose photo from library" selection
    private func choosePhotoFromLibrary(){
        imagePicker.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : Colors.OF_CONTRAST_ITEMS]
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Action of "Delete" selection
    private func deleteCurrentImage() {
        photoOfItemView.image = nil
        photoOfItemView.alpha = 0
        addPhotoButton.alpha = 1
    }
    
    private func alertThatThereIsNoCamera() {
        let alertVC = UIAlertController(            title: titleOfNoCameraAlert,
            message: messageOfNoCameraAlert,
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: okSelectionTitle,
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    private func alertOfDeleteGearConfirmation(forCellAtIndexPath indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil,
                                            message: messageOfAskForDeleteGearConfirmation,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: titleOfDeleteGearConfirmation[0],
                                            style: .destructive,
                                            handler: { action in self.deleteEditedGear() }))
        actionSheet.addAction(UIAlertAction(title: titleOfDeleteGearConfirmation[1],
                                            style: .cancel,
                                            handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func completeConfiguringItem() {
        if isInEditingMode {
            updateGearDetailsToDatabase()
        } else {
            addGearToDatabaseAndAssignToCategory()
        }
        navigationController?.popViewController(animated: true)
    }
    
   // ---   CORE DATA   ---
    
    private func updateGearDetailsToDatabase() {
        
        let currentCategory: Category = (editedGear?.belongToCategory)!
        
        attempFetchCategory(withName: categoryStatus.text!)
        
        let newCategory = selectedCategory()
        
        
        editedGear?.setValue(photoOfItemView.image, forKey: "photo")
        editedGear?.setValue(newCategory, forKey: "belongToCategory")
        editedGear?.setValue(manufacturerTextField.text, forKey: "manufacturer")
        editedGear?.setValue(modelTextField.text, forKey: "model")
        editedGear?.setValue(serialNumberTextField.text, forKey: "serialNumber")
        editedGear?.setValue(priceTextField.text, forKey: "price")
        editedGear?.setValue(usedSwitch.isOn, forKey: "used")
        editedGear?.setValue(dateOfPurchaseTextField.text, forKey: "dateOfPurchase")
        editedGear?.setValue(noteTextView.text, forKey: "note")
        
        if currentCategory != newCategory {
            if currentCategory.haveGear?.count == 0 {
                context.delete(currentCategory)
            }
        }
        
        if let linkedKitsInReality = linkedKitsFetchedResultsController.fetchedObjects {
            linkedKitsInReality.forEach({ kit in
                editedGear?.removeFromBelongToKit(kit)
            })
            checkIfAssignedKitsAreNotEmptyThenReallyAddKitFor(editedGear)
        }
        
        AppDelegate.saveContext()
    }
    
    private func addGearToDatabaseAndAssignToCategory() {
        
        attempFetchCategory(withName: categoryStatus.text!)
        
        let category = selectedCategory()
        
        //Add gear to database
        let gear = NSEntityDescription.insertNewObject(forEntityName: "Gear", into: context) as! Gear
    
        gear.model = self.modelTextField.text
        gear.manufacturer = self.manufacturerTextField.text
        gear.belongToCategory = category
        gear.serialNumber = self.serialNumberTextField.text
        gear.price = self.priceTextField.text
        gear.used = self.usedSwitch.isOn
        gear.photo = self.photoOfItemView.image
        gear.note = self.noteTextView.text
        gear.dateOfPurchase = self.dateOfPurchaseTextField.text
        
        checkIfAssignedKitsAreNotEmptyThenReallyAddKitFor(gear)
        
        AppDelegate.saveContext()
    }
    
    private func checkIfAssignedKitsAreNotEmptyThenReallyAddKitFor(_ gear: Gear?) {
        if !assignedKitsSortedAlphabetically.isEmpty {
            assignedKitsSortedAlphabetically.forEach({ kit in
                gear?.addToBelongToKit(kit)
            })
        }
    }
    
    private func attempFetchCategory(withName name: String) {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: false)
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        categoryFetchedResultsController = fetchedResultsController
        
        do {
            try self.categoryFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    private func selectedCategory() -> Category {
        var category: Category!
        
        if let availableCategory = categoryFetchedResultsController.fetchedObjects {
            if availableCategory.isEmpty { // Not available in database -> add to database
                let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
                newCategory.name = self.categoryStatus.text
                category = newCategory
            } else { // Available in database -> assign gear's category to assigned available category
                category = availableCategory[0]
            }
        }
        return category
    }
    
    
    private func deleteEditedGear() {
        let categoryOfEditedGear: Category = (editedGear?.belongToCategory)!
        
        deleteGear()
        ifCategoryOfEditedGearIsEmptyAfterGearDeletionThenDelete(categoryOfEditedGear)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func deleteGear() {
        context.delete(editedGear!)
        AppDelegate.saveContext()
    }
    
    private func ifCategoryOfEditedGearIsEmptyAfterGearDeletionThenDelete(_ category: Category) {
        if category.haveGear?.count == 0 {
            context.delete(category)
            AppDelegate.saveContext()
        }
    }
    
    private func attemptFetchLinkedKits() {
        let fetchRequest: NSFetchRequest<Kit> = Kit.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        let linkedKitsPredicate = NSPredicate(format: "ANY haveGear = %@", editedGear!)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.predicate = linkedKitsPredicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.linkedKitsFetchedResultsController = controller
        
        do {
            try self.linkedKitsFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    private func attemptFetchUnlinkedKits() {
        let fetchRequest: NSFetchRequest<Kit> = Kit.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        if let editedGear = editedGear {
            let unlinkedKitsPredicate = NSPredicate(format: "SUBQUERY(haveGear, $a, $a CONTAINS %@).@count == 0", editedGear)
            fetchRequest.predicate = unlinkedKitsPredicate
        }
        fetchRequest.sortDescriptors = [nameSort]
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.unlinkedKitsFetchedResultsController = controller
        
        do {
            try self.unlinkedKitsFetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // ---   DELEGATE   ---
    func handleCategory(withName name: String) {
        categoryStatus.text = name
    }
    
    func handle(kit: Kit) {
        assignedKits.append(kit)
        assignedKitsSortedAlphabetically = assignedKits.sorted(by: { $0.name! < $1.name! })
        unassignedKits = unassignedKits.filter { $0 != kit }
        tableView.reloadData()
    }
}
