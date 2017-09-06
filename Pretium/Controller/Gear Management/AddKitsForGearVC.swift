//
//  AddKitForGearController.swift
//  Pretium
//
//  Created by Staham Nguyen on 30/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "cellId"
private let titleOfController = "Kits"

class AddKitsForGearController: UITableViewController, UINavigationControllerDelegate {
    var isInEditingMode = false
    var editedGear: Gear? = nil
    var assignedKits = [Kit]()
    var unassignedKits = [Kit]()
    var delegate: SendAndReceiveDataDelegate? = nil
    private var unassignedKitSortedAlphabetically = [Kit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unassignedKitSortedAlphabetically = unassignedKits.sorted(by: { $0.name! < $1.name! })
        
        tableView.tableFooterView = UIView() // Hide separators between empty cells
        tableView.backgroundColor = Colors.OF_GRAY_BACKGROUND
        
        navigationItem.title = titleOfController
        
        tableView.register(CellInCategoryController.self, forCellReuseIdentifier: cellId)
    }
    
    // ---   TABLE VIEW   ---
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unassignedKits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellInCategoryController
        let unlinkedKit = unassignedKitSortedAlphabetically[indexPath.row]
        cell.avatarImage.clipsToBounds = true
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.bounds.width / 2
        cell.avatarImage.image = unlinkedKit.photo as? UIImage
        cell.label.text = unlinkedKit.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Create.relativeValueScaledToIphone6Plus(of: 80)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenKit = unassignedKitSortedAlphabetically[indexPath.row]
        delegate?.handle(kit: chosenKit)
        navigationController?.popViewController(animated: true)
    }
}
