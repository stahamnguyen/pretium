//
//  CalculatingVC.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

private let titleOfSelection = ["Stacking ND Filter", "Depth of Field"]
private let cellId = "cellId"
private let titleOfController = "Calculating"
private let defaultTitleOfBackBarButton = "Back"

class CalculatingController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackground()
        
        navigationItem.title = titleOfController
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.OF_CONTRAST_ITEMS]
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorColor = Colors.OF_INNER_PART_OF_GRADIENT_BACKGROUND
        
        tableView.register(CellInConfigureGearController.self, forCellReuseIdentifier: cellId)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: defaultTitleOfBackBarButton,
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: nil,
                                                           action: nil)
    }
    
    private func createBackground() {
        let backgroundView = RadialGradientView()
        backgroundView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: Screen.WIDTH_OF_IPHONE_6PLUS, height: Screen.HEIGHT_OF_IPHONE_6PLUS)
        backgroundView.insideColor = Colors.OF_INNER_PART_OF_GRADIENT_BACKGROUND
        backgroundView.outsideColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        tableView.backgroundView = backgroundView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleOfSelection.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellInConfigureGearController
        
        switch indexPath.row {
        case 0:
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
        default:
            cell.type = .baseCell
            cell.backgroundColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
            cell.mainLabel.text = titleOfSelection[indexPath.row - 1]
            cell.mainLabel.textColor = Colors.OF_BUTTON_TITLE
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            return
        case 2:
            let depthOfFieldController = DepthOfFieldController()
            depthOfFieldController.navigationItem.title = titleOfSelection[indexPath.row - 1]
            navigationController?.pushViewController(depthOfFieldController, animated: true)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return Create.relativeValueScaledToIphone6Plus(of: 40)
        default:
            return Create.relativeValueScaledToIphone6Plus(of: 56)
        }
        
    }
}
