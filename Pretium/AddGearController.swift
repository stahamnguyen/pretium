//
//  AddGearController.swift
//  Pretium
//
//  Created by Staham Nguyen on 07/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

private let cellOfManufacturerAndModel = "1"
private let cellOfCategory = "2"
private let cellOfSerialNumber = "3"
private let cellOfPrice = "4"
private let cellOfUsed = "5"
private let cellOfDateOfPurchase = "6"
private let cellOfAddToKit = "7"
private let cellOfNote = "8"

class AddGearController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, SendAndReceiveDataDelegate {
    
    private let titleOfViewController = "New Gear"
    
    private let sectionTitle = ["", "", "PURCHASE INFORMATION", "ASSIGNED KITS", "NOTES"]
    
    private var titleOfCell: [[String]] {
        let titleOfCellInSectionTwo = ["Category", "Serial No."]
        let titleOfCellInSectionThree = ["Price", "Used", "Date of Purchase"]
        let titleOfCellInSectionFour = ["Add to kit"]
        return [titleOfCellInSectionTwo, titleOfCellInSectionThree, titleOfCellInSectionFour]
    }
    
    private let defaultSerialNumberPlaceholder = "000 000 000"
    
    private let titleOfPhotoPickerMenu = ["Take a photo", "Choose from library", "Delete", "Cancel"]
    
    private let titleOfNoCameraAlert = "No Camera"
    private let messageOfNoCameraAlert = "Sorry, this device has no camera"
    private let okSelectionTitle = "OK"
    
    private let rightBarButtonTitle = "Add"
    
    private var indexPathArray = [IndexPath]()
    
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
    let imagePicker = UIImagePickerController()
    
    var categoryFetchedResultsController = NSFetchedResultsController<Category>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup title of the view controller and create "Add" button
        navigationItem.title = titleOfViewController
        let addGearButton = UIBarButtonItem(title: rightBarButtonTitle,
                                            style: .done,
                                            target: self,
                                            action: #selector(completeAddingItem))
        navigationItem.rightBarButtonItem = addGearButton
        self.addGearButton = addGearButton
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.OF_CONTRAST_ITEMS]

        disableAddGearButtonIfModelTextFieldIsEmpty()
        
        imagePicker.delegate = self
        
        self.hideKeyboardWhenTappingAround()
        
        //Register cell ID
        let cellIdArray = [cellOfManufacturerAndModel, cellOfCategory, cellOfSerialNumber, cellOfPrice, cellOfUsed, cellOfDateOfPurchase, cellOfAddToKit, cellOfNote]
        cellIdArray.forEach({ cellId in
            tableView.register(CellInAddGearController.self, forCellReuseIdentifier: cellId)
        })
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPhotoButton.addTarget(self, action: #selector(showPhotoPickerMenu), for: .touchUpInside)
        modelTextField.addTarget(self, action: #selector(disableAddGearButtonIfModelTextFieldIsEmpty), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Basic UITableView setup
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return titleOfCell[0].count
        case 2:
            return titleOfCell[1].count
        default:
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    //Setup cells for sections
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        //Section 1 - "Manufacturer and model" cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOfManufacturerAndModel, for: indexPath) as! CellInAddGearController
            //Check if the cell has been reused yet not to setup more overlapping textfields
            if (!indexPathArray.contains(indexPath)) {
                indexPathArray.append(indexPath)
                cell.type = .manufacturerAndModelCell
                self.manufacturerTextField = cell.manufacturerTextField
                self.modelTextField = cell.modelTextField
                self.addPhotoButton = cell.addPhotoButton
                self.photoOfItemView = cell.photoOfItemView
                self.manufacturerTextField.delegate = self
                self.modelTextField.delegate = self
            }
            return cell
        
        //Section 5 - "Note" cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOfNote, for: indexPath) as! CellInAddGearController
            //Check if the cell has been reused yet not to setup more overlapping textviews
            if (!indexPathArray.contains(indexPath)) {
                indexPathArray.append(indexPath)
                cell.type = .noteCell
                self.noteTextView = cell.noteTextView
            }
            return cell
        
        //Section 4 - "Add to Kits" cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOfAddToKit, for: indexPath) as! CellInAddGearController
            cell.type = .baseCell
            cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
            cell.mainLabel.textColor = .blue
            cell.accessoryType = .disclosureIndicator
            return cell
        
        //Section 2 - "Category" and "Serial Number" cells
        case 1:
            switch indexPath.row {
                
            // "Category" cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfCategory, for: indexPath) as! CellInAddGearController
                cell.type = .categoryCell
                cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                self.categoryStatus = cell.statusLabel
                return cell
                
            // "Serial Number" cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfSerialNumber, for: indexPath) as! CellInAddGearController
                if (!indexPathArray.contains(indexPath)) {
                    indexPathArray.append(indexPath)
                    cell.type = .cellWithTextFieldInTheRight
                    cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                    cell.statusTextField.placeholder = defaultSerialNumberPlaceholder
                    cell.statusTextField.keyboardType = .numberPad
                    self.serialNumberTextField = cell.statusTextField
                }
                return cell
            }
        
        //Other section (Section 3) - "Price", "Used" and "Date of Purchase" cells
        default:
            switch indexPath.row {
            //"Price" cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfPrice, for: indexPath) as! CellInAddGearController
                //Check if the cell has been reused yet not to setup more overlapping textviews
                if (!indexPathArray.contains(indexPath)) {
                    indexPathArray.append(indexPath)
                    cell.type = .cellWithTextFieldInTheRight
                    cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                    
                    cell.statusTextField.type = .priceSetter
                    self.priceTextField = cell.statusTextField
                }
                return cell
             
            //"Used" cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfUsed, for: indexPath) as! CellInAddGearController
                cell.type = .cellWithSwitcher
                cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.item]
                self.usedSwitch = cell.usedSwitch
                return cell
            
            //"Date of Purchase" cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellOfDateOfPurchase, for: indexPath) as! CellInAddGearController
                if (!indexPathArray.contains(indexPath)) {
                    indexPathArray.append(indexPath)
                    cell.type = .cellWithTextFieldInTheRight
                    cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.row]
                    cell.statusTextField.type = .datePicker
                    self.dateOfPurchaseTextField = cell.statusTextField
                }
                return cell
            }
        }
    }
    
    //Setup custom section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Colors.OF_GRAY_BACKGROUND
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.gray.cgColor
        
        let headerLabel = UILabel(frame: Create.frameScaledToIphone6Plus(x: 23, y: 20, width: tableView.bounds.width / Screen.RATIO_WITH_IPHONE_6PLUS, height: 0))
        headerLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 13, forIphone6: 15, forIphone6Plus: 17), weight: UIFontWeightThin)
        headerLabel.textColor = .black
        headerLabel.text = sectionTitle[section]
        headerLabel.sizeToFit()
        view.addSubview(headerLabel)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Create.relativeValueScaledToIphone6Plus(of: 45)
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
        switch indexPath.section {
        case 1:
            let categorySelectionViewController = CategorySelectionViewController()
            categorySelectionViewController.delegate = self
            categorySelectionViewController.currentSelection = categoryStatus.text!
            navigationController?.pushViewController(categorySelectionViewController, animated: true)
        default:
            return
        }
    }
    
    //Text field configuration
    func disableAddGearButtonIfModelTextFieldIsEmpty(){
        if (self.modelTextField.text ?? "").isEmpty {
            addGearButton.isEnabled = false
        } else {
            addGearButton.isEnabled = true
        }
    }
    
    //Image picker setup
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Display chosen image
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoOfItemView.image = chosenImage
            photoOfItemView.alpha = 1
            addPhotoButton.alpha = 0
        } else {
            photoOfItemView.image = nil
        }
        
        //Add tap gesture for the image view
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showPhotoPickerMenu))
        singleTap.numberOfTapsRequired = 1
        photoOfItemView.isUserInteractionEnabled = true
        photoOfItemView.addGestureRecognizer(singleTap)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Colors.OF_CONTRAST_ITEMS]
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
        let alertVC = UIAlertController(
            title: titleOfNoCameraAlert,
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
    
    @objc private func completeAddingItem() {
        addGearToDatabaseAndAssignToCategory()
        navigationController?.popViewController(animated: true)
    }
    
    // CoreData funcs
    
    func addGearToDatabaseAndAssignToCategory() {
        attempFetchCategoryWithTheSameNameToTheCategoryTextField()
        
        var category: Category?
        
        // Check if the category has been available in database yet
        if let availableCategory = categoryFetchedResultsController.fetchedObjects {
            if availableCategory.isEmpty { // Not yet -> add to database
                let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
                newCategory.name = self.categoryStatus.text
                category = newCategory
            } else { // Yes -> assign gear's category to assigned available category
                category = availableCategory[0]
            }
        }
        
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
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func attempFetchCategoryWithTheSameNameToTheCategoryTextField() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: false)
        let nameOfCategory = self.categoryStatus.text
        let predicate = NSPredicate(format: "name = %@", nameOfCategory!)
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
    
    //Func from protocol to receive data
    func handleData(data: String) {
        categoryStatus.text = data
    }
}
