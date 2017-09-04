//
//  CellInCategoryControlller.swift
//  Pretium
//
//  Created by Staham Nguyen on 16/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CellInCategoryController: UITableViewCell {
    
    let avatarImage = UIImageView()
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImage.frame = Create.frameScaledToIphone6Plus(x: 23, y: 13, width: 54, height: 54)
        avatarImage.contentMode = .scaleAspectFit
        addSubview(avatarImage)
        
        label.frame = Create.frameScaledToIphone6Plus(x: 97, y: 28.5, width: 294, height: 23)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
