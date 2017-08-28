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

class ConfigureKitController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let templateKitTitles = ["LIVE EVENT KIT", "STUDIO KIT", "TRAVEL KIT", "OUTDOOR KIT", "WEDDING KIT"]
    private let titleOfViewController = "Create Kit"
    private let titleOfNameKitControllerBackButton = "Cover"
    
    private let padding = Create.relativeValueScaledToIphone6Plus(of: 10)
    
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
        
        //Register class for cell ID
        collectionView?.register(CellInConfigureKitController.self, forCellWithReuseIdentifier: baseCellId)
        collectionView?.register(CellInConfigureKitController.self, forCellWithReuseIdentifier: createCustomKitCellId)
    }
    
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
            return
        default:
            let nameKitController = NameKitController()
            let layout = UICollectionViewFlowLayout()
            let nextAddGearToKitController = AddGearToKitController(collectionViewLayout: layout)
            
            nameKitController.originalNameOfKit = templateKitTitles[indexPath.row]
            
            nameKitController.nextAddGearToKitController = nextAddGearToKitController
            nameKitController.nextAddGearToKitController.nameOfKit = templateKitTitles[indexPath.row]
            nameKitController.nextAddGearToKitController.image = UIImage(named: templateKitTitles[indexPath.row])!
            
            navigationController?.pushViewController(nameKitController, animated: true)
        }
    }
}
