
//
//  ButtonCell.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    var labels = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generateLabelsArray(withNames: "Add Gear", "Add Kit", "Cancel")
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateLabelsArray(withNames names : String...) {
        labels = names.map { name in
            let label = UILabel()
            label.text = name
            label.textColor = .blue
            label.layer.cornerRadius = 4
            label.frame = bounds
            return label
        }
    }
}
