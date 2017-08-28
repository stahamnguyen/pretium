//
//  NameKitController.swift
//  Pretium
//
//  Created by Staham Nguyen on 26/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class NameKitController: UIViewController, UITextFieldDelegate {
    
    var originalNameOfKit = ""
    var image = UIImage()
    var nextAddGearToKitController = AddGearToKitController()
    private let coverImage = UIImageView()
    private let blurredBackgroundImage = UIImageView()
    let nameTextField = UITextField()
    private var rightBarButton = UIBarButtonItem()
    
    var isCustomed = false
    
    private let placeholderOfNameTextField = "Name of this kit"
    private let titleOfViewController = "Name"
    private let defaultLeftBarButtonTitle = "Done"
    private let leftBarButtonTitleAfterCompletingFillingNameTextField = "Next"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleOfViewController
        
        setupRightBarButton()
        
        setupBlurredBackgroundImage()
        setupAvatarImage()
        setupNameTextField()

    }
    
    // ---   SETUP UI   ---
    
    private func setupRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: defaultLeftBarButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonPressed))
        self.rightBarButton = rightBarButton
        navigationItem.rightBarButtonItem = self.rightBarButton
    }
    
    private func setupBlurredBackgroundImage() {
        
        if !isCustomed {
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
        nameTextField.attributedPlaceholder = NSAttributedString(string:placeholderOfNameTextField, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        nameTextField.text = originalNameOfKit.capitalized
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
        rightBarButton.title = leftBarButtonTitleAfterCompletingFillingNameTextField
    }
    
    // ---   RIGHT BAR BUTTON FUNS   ---
    @objc private func rightBarButtonPressed() {
        switch rightBarButton.title! {
        case leftBarButtonTitleAfterCompletingFillingNameTextField:
            navigationController?.pushViewController(nextAddGearToKitController, animated: true)
        default:
            nameTextField.resignFirstResponder()
        }
    }
}
