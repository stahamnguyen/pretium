//
//  AddButtonLauncher.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class AddButtonLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let headerCellId = "headerCellId"
    let buttonCellId = "buttonCellId"
    
    let blackView = UIView()
    let collectionOfButtons: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10 * Screen.HEIGTH / 736, right: 0)
        layout.minimumLineSpacing = 0
        let collectionOfButtons = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionOfButtons.backgroundColor = UIColor(white: 0, alpha: 0)
        return collectionOfButtons
    }()
    
    func showAddView() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViews)))
            
            window.addSubview(blackView)
            window.addSubview(collectionOfButtons)
            
            collectionOfButtons.frame = CGRect(x: 10 * Screen.WIDTH / 414, y: Screen.HEIGTH, width: Screen.WIDTH * (1 - 20 / 414), height: Screen.HEIGTH / 2)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionOfButtons.frame = CGRect(x: 10 * Screen.WIDTH / 414, y: Screen.HEIGTH / 2, width: self.collectionOfButtons.frame.width, height: self.collectionOfButtons.frame.height)
            }, completion: nil)
        }
    }
    
    @objc private func dismissViews() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.collectionOfButtons.frame = CGRect(x: 10 * Screen.WIDTH / 414, y: Screen.HEIGTH, width: self.collectionOfButtons.frame.width, height: self.collectionOfButtons.frame.height)
            self.blackView.alpha = 0
        }, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0 ? 3 : 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 && indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellId, for: indexPath) as! HeaderCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCellId, for: indexPath) as! ButtonCell
            
            //Round corners of third and last cells and add button to all cells
            if indexPath.item == 0 && indexPath.section == 1 {
                cell.addSubview(cell.labels[indexPath.item + cell.labels.count - 1])
                cell.layer.cornerRadius = 4
            } else {
                cell.addSubview(cell.labels[indexPath.item - 1])
                if indexPath.item == 2 {
                    let maskPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 4, height: 4))
                    let maskLayer = CAShapeLayer()
                    maskLayer.frame = cell.bounds
                    maskLayer.path = maskPath.cgPath
                    cell.layer.mask = maskLayer
                }
            }
            return cell
        }
    }
    
    //Sst size of cells. Given that the buttons collection view, after subtracted the distance between 2 section, is divided into 7.5 pieces, the header takes 1 while the others takes 2
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height - 20 * Screen.HEIGTH / 736) * (indexPath.item == 0 && indexPath.section == 0 ? 1 / 7 : 2 / 7))
    }
    
    override init() {
        super.init()
        collectionOfButtons.dataSource = self
        collectionOfButtons.delegate = self
        collectionOfButtons.register(HeaderCell.self, forCellWithReuseIdentifier: "headerCellId")
        collectionOfButtons.register(ButtonCell.self, forCellWithReuseIdentifier: "buttonCellId")
    }
}
