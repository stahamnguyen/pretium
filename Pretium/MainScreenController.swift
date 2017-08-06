//
//  ViewController.swift
//  Pretium
//
//  Created by Staham Nguyen on 29/07/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class MainScreenController: UIViewController {
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackground()
        createStackViewOfLogoAndBrand()
        createStackViewOfButtons()
        
        buttons[0].addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func createBackground() {
        let backgroundView = RadialGradientView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: Screen.WIDTH, height: Screen.HEIGTH)
        backgroundView.insideColor = Colors.OF_INNER_PART_OF_GRADIENT_BACKGROUND
        backgroundView.outsideColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        view.addSubview(backgroundView)
    }
    
    private func createLogoAndBrand() -> [UIView] {
        //Logo
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.frame = CGRect(x: 0, y: 0, width: Screen.WIDTH * 165 / 414, height: Screen.HEIGTH * 165 / 736)
        logo.contentMode = .scaleAspectFit
        //Brand
        let brand = UIImageView(image: UIImage(named: "pretium"))
        brand.frame = CGRect(x: 0, y: 0, width: Screen.WIDTH * 267 / 414, height: Screen.HEIGTH * 61 / 736)
        brand.contentMode = .scaleAspectFit
        
        return [logo, brand]
    }
    
    private func createButtons(withName named: String...) -> [UIButton] {
        buttons = named.map { name in
            let button = CustomButtonMainScreen()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(name, for: .normal)
            button.setTitleColor(Colors.OF_BUTTON_TITLE, for: .normal)
            button.backgroundColor = Colors.OF_BUTTON_BACKGROUND
            return button
        }
        return buttons
    }
    
    private func createStackViewOfLogoAndBrand() {
        //Basic settings
        let stackView = UIStackView(arrangedSubviews: createLogoAndBrand())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Screen.HEIGTH * 22 / 736
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        view.addSubview(stackView)
        
        //Set constraint
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Screen.WIDTH * 73.5 / 414).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Screen.HEIGTH * 115 / 736).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Screen.WIDTH * 73.5 / 414).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: Screen.HEIGTH * 247 / 736).isActive = true
    }
    
    private func createStackViewOfButtons() {
        // Basic settings
        let stackView = UIStackView(arrangedSubviews: createButtons(withName: "Gear Management", "Calculating", "Weather"))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Screen.HEIGTH * 12 / 736
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        // Set constraint
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Screen.WIDTH * 80 / 414).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Screen.HEIGTH * 40 / 736).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Screen.WIDTH * 80 / 414).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: Screen.HEIGTH * 295 / 736).isActive = true
    }
    
    @objc private func buttonClicked(sender: CustomButtonMainScreen!) {
        let gearManagementController = GearManagementController()
        navigationController?.pushViewController(gearManagementController, animated: true)
    }
}

