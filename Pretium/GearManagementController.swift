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
        let segmentedController = UISegmentedControl(items: items)
        segmentedController.frame = CGRect(x: 0, y: 0, width: 205 * Screen.RATIO_WITH_IPHONE_7PLUS, height: 25 * Screen.RATIO_WITH_IPHONE_7PLUS)
        segmentedController.selectedSegmentIndex = 0
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentedController)
    }
    
    private func createAddButtonAndSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.search))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
        let buttons = [addButton, searchButton]
        navigationItem.rightBarButtonItems = buttons
    }
    
    @objc private func search() {
        
    }
    
    @objc private func add() {
        let actionSheet = UIAlertController(title: nil, message: "What would you like to add?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Add Gear", style: .default, handler: { action in self.pushToAddGearController()}))
        actionSheet.addAction(UIAlertAction(title: "Add Kit", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func pushToAddGearController() {
        let addGearController = AddGearController()
        navigationController?.pushViewController(addGearController, animated: true)
    }
}
