//
//  NameKitController.swift
//  Pretium
//
//  Created by Staham Nguyen on 26/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

class NameKitController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var originalNameOfKit = ""
    var image = UIImage()
    var previousGearInKitControllerIfInEditingMode: GearInCategoryOrKitController? = nil
    private let coverImage = UIImageView()
    private let blurredBackgroundImage = UIImageView()
    let nameTextField = UITextField()
    private var rightBarButton = UIBarButtonItem()
    private let imagePicker = UIImagePickerController()
    
    var isCustomed = false
    var isEdited = false
    var editedKit: Kit? = nil
    
    private let placeholderOfNameTextField = "Name of this kit"
    private let titleOfViewController = "Name"
    private let defaultLeftBarButtonTitle = "Done"
    private let rightBarButtonTitleAfterCompletingFillingNameTextField = "Next"
    private let rightBarButtonTitleAfterCompletingFillingNameTextFieldInEditingMode = "Save"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleOfViewController
        
        setupRightBarButton()
        
        setupBlurredBackgroundImage()
        setupAvatarImage()
        setupNameTextField()
        
        nameTextField.addTarget(self, action: #selector(disableRightBarButtonIfNameTextFieldIsEmpty), for: .editingChanged)
        
        if isEdited {
            addTapGestureForImageView()
            imagePicker.delegate = self
        }
        
        if isCustomed {
            rightBarButton.isEnabled = false
        }
    }
    
    // ---   SETUP UI   ---
    
    private func setupRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: defaultLeftBarButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonPressed))
        self.rightBarButton = rightBarButton
        navigationItem.rightBarButtonItem = self.rightBarButton
    }
    
    private func setupBlurredBackgroundImage() {
        
        if !isCustomed && !isEdited {
            let image = UIImage(named: originalNameOfKit)
            self.image = image!
        }
       
        blurredBackgroundImage.image = image
        blurredBackgroundImage.frame = view.frame
        blurredBackgroundImage.contentMode = .scaleToFill
        view.addSubview(blurredBackgroundImage)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func setupAvatarImage() {
        coverImage.layer.cornerRadius = 4
        coverImage.clipsToBounds = true
        coverImage.image = image
        coverImage.contentMode = .scaleAspectFill
        coverImage.frame = Create.frameScaledToIphone6Plus(x: 111, y: 170, width: 192, height: 192)
        view.addSubview(coverImage)
    }
    
    private func setupNameTextField() {
        nameTextField.delegate = self
        
        nameTextField.returnKeyType = .done
        nameTextField.attributedPlaceholder = NSAttributedString(string:placeholderOfNameTextField, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        if !isCustomed {
            nameTextField.text = isEdited ? originalNameOfKit : originalNameOfKit.capitalized
        } else {
            nameTextField.text = nil
        }
        
        nameTextField.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 17, forIphone6: 19, forIphone6Plus: 21))
        nameTextField.textAlignment = .center
        nameTextField.textColor = .white
        nameTextField.frame = Create.frameScaledToIphone6Plus(x: 111, y: 382, width: 192, height: 25)
        view.addSubview(nameTextField)
        
        nameTextField.becomeFirstResponder()
    }
    
    // ---   SETUP TEXT FIELD DELEGATE   ---
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightBarButton.title = defaultLeftBarButtonTitle
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rightBarButton.title = isEdited ? rightBarButtonTitleAfterCompletingFillingNameTextFieldInEditingMode : rightBarButtonTitleAfterCompletingFillingNameTextField
    }
    
    // ---   RIGHT BAR BUTTON FUNCS   ---
    @objc private func rightBarButtonPressed() {
        switch rightBarButton.title! {
        case rightBarButtonTitleAfterCompletingFillingNameTextField:
            pushToAddGearToKitController()
        case rightBarButtonTitleAfterCompletingFillingNameTextFieldInEditingMode:
            updateKitDetails()
        default:
            nameTextField.resignFirstResponder()
        }
    }
    
    private func pushToAddGearToKitController() {
        let layout = UICollectionViewFlowLayout()
        let addGearToKitController = AddGearToKitController(collectionViewLayout: layout)
        addGearToKitController.nameOfKit = nameTextField.text!
        addGearToKitController.image = self.image
        navigationController?.pushViewController(addGearToKitController, animated: true)
    }
    
    private func updateKitDetails() {
        previousGearInKitControllerIfInEditingMode?.navigationItem.title = nameTextField.text
        editedKit?.setValue(nameTextField.text, forKey: "name")
        editedKit?.setValue(image, forKey: "photo")
        
        AppDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func disableRightBarButtonIfNameTextFieldIsEmpty() {
        if (self.nameTextField.text ?? "").isEmpty {
            rightBarButton.isEnabled = false
        } else {
            rightBarButton.isEnabled = true
        }
    }
    
    // ---   COVER IMAGE FUNCS   ---
    
    private func addTapGestureForImageView() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showPhotoPickerMenu))
        singleTap.numberOfTapsRequired = 1
        coverImage.isUserInteractionEnabled = true
        coverImage.addGestureRecognizer(singleTap)
    }
    
    // ---   IMAGE PICKER CONTROLLER FUNCS   ---
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Display chosen image
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = chosenImage
            self.coverImage.image = image
            self.blurredBackgroundImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func showPhotoPickerMenu() {
        nameTextField.resignFirstResponder()
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: titleOfPhotoPickerMenu[0],
                                            style: .default,
                                            handler: { action in self.takeAPhoto()}))
        actionSheet.addAction(UIAlertAction(title: titleOfPhotoPickerMenu[1],
                                            style: .default,
                                            handler: { action in self.choosePhotoFromLibrary()}))
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
}
