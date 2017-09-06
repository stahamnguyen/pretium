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
        
        buttons[0].addTarget(self, action: #selector(self.gearManagementButtonClicked), for: .touchUpInside)
        buttons[1].addTarget(self, action: #selector(self.calculatingButtonClicked), for: .touchUpInside)
        buttons[2].addTarget(self, action: #selector(self.weatherButtonClicked), for: .touchUpInside)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        backgroundView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: Screen.WIDTH_OF_IPHONE_6PLUS, height: Screen.HEIGHT_OF_IPHONE_6PLUS)
        backgroundView.insideColor = Colors.OF_INNER_PART_OF_GRADIENT_BACKGROUND
        backgroundView.outsideColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        view.addSubview(backgroundView)
    }
    
    private func createStackViewOfLogoAndBrand() {
        let stackView = UIStackView(arrangedSubviews: createLogoAndBrand())
        generalSetup(forStackView: stackView, withSpacing: 22)
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        view.addSubview(stackView)
        
        setupConstraints(forStackView: stackView, withLeftConstraint: 73.5, rightConstraint: -73.5, topConstraint: 115, bottomConstraint: nil, heightConstraint: 247)
    }
    
    private func createStackViewOfButtons() {
        let stackView = UIStackView(arrangedSubviews: byCreatingButtons(withName: "Gear Management", "Calculating", "Weather"))
        generalSetup(forStackView: stackView, withSpacing: 12)
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        setupConstraints(forStackView: stackView, withLeftConstraint: 80, rightConstraint: -80, topConstraint: nil, bottomConstraint: -40, heightConstraint: 295)
    }
    
    private func createLogoAndBrand() -> [UIView] {
        let logo = setupImage(forObject: "logo", withFrameX: 0, y: 0, width: 165, height: 165)
        let brand = setupImage(forObject: "brand", withFrameX: 0, y: 0, width: 267, height: 61)
        
        return [logo, brand]
    }
    
    private func byCreatingButtons(withName named: String...) -> [UIButton] {
        buttons = named.map { name in
            let button = CustomButtonMainScreen()
            button.setTitle(name, for: .normal)
            return button
        }
        return buttons
    }
    
    private func setupImage(forObject object: String, withFrameX x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImageView {
        let imageObject = UIImageView(image: UIImage(named: object))
        imageObject.frame = Create.frameScaledToIphone6Plus(x: x, y: y, width: width, height: height)
        imageObject.contentMode = .scaleAspectFit
        return imageObject
    }
    
    private func generalSetup(forStackView stackView: UIStackView, withSpacing spacing: CGFloat) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Create.relativeValueScaledToIphone6Plus(of: spacing)
    }
    
    private func setupConstraints(forStackView stackView: UIStackView, withLeftConstraint leftConstraint: CGFloat, rightConstraint: CGFloat, topConstraint: CGFloat?, bottomConstraint: CGFloat?, heightConstraint: CGFloat) {
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Create.relativeValueScaledToIphone6Plus(of: leftConstraint)).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Create.relativeValueScaledToIphone6Plus(of: rightConstraint)).isActive = true
        if let topConstraint = topConstraint {
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Create.relativeValueScaledToIphone6Plus(of: topConstraint)).isActive = true
        }
        if let bottomConstraint = bottomConstraint {
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Create.relativeValueScaledToIphone6Plus(of: bottomConstraint)).isActive = true
        }
        stackView.heightAnchor.constraint(equalToConstant: Create.relativeValueScaledToIphone6Plus(of: heightConstraint)).isActive = true
    }
    
    @objc private func gearManagementButtonClicked() {
        let layout = UICollectionViewFlowLayout()
        let gearManagementController = GearManagementController(collectionViewLayout: layout)
        Current.GEAR_MANAGEMENT_CONTROLLER = gearManagementController
        navigationController?.pushViewController(gearManagementController, animated: true)
    }
    
    @objc private func calculatingButtonClicked() {
        let calculatingController = CalculatingController()
        navigationController?.pushViewController(calculatingController, animated: true)
    }
    
    @objc private func weatherButtonClicked() {
        let weatherController = WeatherController()
        navigationController?.pushViewController(weatherController, animated: true)
    }
}
