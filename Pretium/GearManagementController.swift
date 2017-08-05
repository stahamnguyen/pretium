//
//  GearManagementScreenViewController.swift
//  Pretium
//
//  Created by Staham Nguyen on 31/07/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class GearManagementController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackground()
        createSegmentedControl(withItems: "Kits", "Categories")
        createAddButtonAndSearchButton()
        
    }
    
    private func createBackground() {
        let background = UIView()
        background.frame = CGRect(x: 0, y: 0, width: Screen.WIDTH, height: Screen.HEIGTH)
        background.backgroundColor = UIColor.white
        view.addSubview(background)
    }
    
    private func createSegmentedControl(withItems items: String...) {
        let segmentedController = CustomSegmentedControl(items: items)
        segmentedController.frame = CGRect(x: 0, y: 0, width: Screen.WIDTH * 205 / 414, height: Screen.HEIGTH * 25 / 736)
        segmentedController.selectedSegmentIndex = 0
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentedController)
    }
    
    private func createAddButtonAndSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.search))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addGear))
        let buttons = [addButton, searchButton]
        navigationItem.rightBarButtonItems = buttons
    }
    
    @objc private func search() {
        
    }
    
    @objc private func addGear() {
        if let window = UIApplication.shared.keyWindow {
            let blackView = UIView()
            blackView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
            window.addSubview(blackView)
            blackView.frame = window.frame
        }
        
        
    }
    
    
    

}
