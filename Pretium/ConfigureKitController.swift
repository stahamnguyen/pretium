//
//  ConfigureKitController.swift
//  Pretium
//
//  Created by Staham Nguyen on 26/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

private let baseCellId = "1"
private let createCustomKitCellId = "2"

import UIKit

class ConfigureKitController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let templateKitTitles = ["LIVE EVENT KIT", "STUDIO KIT", "TRAVEL KIT", "OUTDOOR KIT", "WEDDING KIT"]
    private let titleOfViewController = "Create Kit"
    private let titleOfNameKitControllerBackButton = "Cover"
    
    private let imagePicker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = titleOfViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: titleOfNameKitControllerBackButton,
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: nil,
                                                           action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        //Partly configure cell's padding (layout)
        partlySetupLayout(withPadding: padding)
        
        imagePicker.delegate = self
        
        //Register class for cell ID
        collectionView?.register(CellInConfigureKitController.self, forCellWithReuseIdentifier: baseCellId)
        collectionView?.register(CellInConfigureKitController.self, forCellWithReuseIdentifier: createCustomKitCellId)
    }
    
    // ---   COLLECTION VIEW SETUP   ---
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateKitTitles.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case templateKitTitles.count:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: createCustomKitCellId, for: indexPath) as! CellInConfigureKitController
            cell.type = .createCustomKitCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellId, for: indexPath) as! CellInConfigureKitController
            cell.type = .baseCell
            cell.title.text = templateKitTitles[indexPath.row]
            cell.backgroundImage.image = UIImage(named: cell.title.text!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Create.relativeValueScaledToIphone6Plus(of: 192), height: Create.relativeValueScaledToIphone6Plus(of: 192))
    }
    
    //Partly configure cell's padding (layout)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case templateKitTitles.count:
            showPhotoPickerMenu()
        default:
            let nameKitController = NameKitController()
            nameKitController.originalNameOfKit = templateKitTitles[indexPath.row]
            
            navigationController?.pushViewController(nameKitController, animated: true)
        }
    }
    
    // ---   IMAGE PICKER CONTROLLER FUNCS   ---
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Display chosen image
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let nameKitController = NameKitController()
            nameKitController.isCustomed = true
            nameKitController.image = chosenImage
            navigationController?.pushViewController(nameKitController, animated: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showPhotoPickerMenu() {
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
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Colors.OF_CONTRAST_ITEMS]
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
