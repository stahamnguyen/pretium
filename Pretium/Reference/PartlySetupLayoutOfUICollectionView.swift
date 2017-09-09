//
//  UICollectionViewControllerEx.swift
//  Pretium
//
//  Created by Staham Nguyen on 27/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

extension UICollectionViewController {
    func partlySetupLayout(withPadding padding: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        collectionView?.collectionViewLayout = layout
    }
}
