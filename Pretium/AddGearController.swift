//
//  AddGearController.swift
//  Pretium
//
//  Created by Staham Nguyen on 07/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class AddGearController : UITableViewController {
    
    let sectionTitle = ["", "", "PURCHASE INFORMATION", "ASSIGNED KITS", "NOTES"]
    let cellId = "cellId"
    var titleOfCell: [[String]] {
        let titleOfCellInSectionTwo = ["Category", "Serial No."]
        let titleOfCellInSectionThree = ["Receipt", "Price", "Used", "Date of Purchase"]
        let titleOfCellInSectionFour = ["Add to kit"]
        return [titleOfCellInSectionTwo, titleOfCellInSectionThree, titleOfCellInSectionFour]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellInAddGearController.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellInAddGearController
        if (indexPath.section == 0) {
            cell.type = .manufacturerAndModelCell
        } else if (indexPath.section == 4) {
            cell.type = .noteCell
        } else if (indexPath.section == 2 && indexPath.row == 2) {
            cell.type = .cellWithSwitcher
            cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.item]
        } else {
            cell.type = .normalCell
            cell.mainLabel.text = titleOfCell[indexPath.section - 1][indexPath.item]
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        let headerLabel = UILabel(frame: CGRect(x: 23 * Screen.RATIO_WITH_IPHONE_7PLUS, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        headerLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 13, forIphone6: 15, forIphone6Plus: 17), weight: UIFontWeightThin)
        headerLabel.textColor = .black
        headerLabel.text = sectionTitle[section]
        headerLabel.sizeToFit()
        view.addSubview(headerLabel)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25 * Screen.RATIO_WITH_IPHONE_7PLUS
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle[section]
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 112 * Screen.RATIO_WITH_IPHONE_7PLUS
        } else if (indexPath.section == 4) {
            return 190 * Screen.RATIO_WITH_IPHONE_7PLUS
        } else {
            return 56 * Screen.RATIO_WITH_IPHONE_7PLUS
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 * Screen.RATIO_WITH_IPHONE_7PLUS
    }
}
