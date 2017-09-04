//
//  CategorySelectionViewController.swift
//  Pretium
//
//  Created by Staham Nguyen on 16/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CategorySelectionViewController: UITableViewController, UINavigationControllerDelegate {
    
    private let titleOfViewController = "Category"
    private let cellId = "cellId"
    private let labelArray = ["Cameras", "Lens", "Gadgets", "Computers", "Data Storage", "Lighting - Flash", "Bags and Cases", "Tripods", "Accessories", "Audio", "Uncategorized"]
    var currentSelection: String = "Uncategorized"
    
    var delegate: SendAndReceiveDataDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CellInCategoryController.self, forCellReuseIdentifier: cellId)
        navigationItem.title = titleOfViewController

    }
    
    // ---   TABLE VIEW   ---
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellInCategoryController
        cell.label.text = labelArray[indexPath.row]
        cell.avatarImage.image = UIImage(named: labelArray[indexPath.row])
        if (cell.label.text == currentSelection) { //Display checkmark for the currently selected category
            cell.accessoryType = .checkmark
        } else { //Avoid checkmark repeating when reusing cell
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Create.relativeValueScaledToIphone6Plus(of: 80)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let labelOfCell = labelArray[indexPath.row]
        delegate?.handleCategory(withName: labelOfCell)
        navigationController?.popViewController(animated: true)
    }
}
