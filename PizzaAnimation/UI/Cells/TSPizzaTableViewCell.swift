//
//  TSPizzaTableViewCell.swift
//  PizzaAnimation
//
//  Created by Tubik Studio on 8/5/16.
//  Copyright © 2016 Tubik Studio. All rights reserved.
//

import UIKit

let kMinDynamicXConstant:CGFloat = 15
let kMinDynamicYConstant:CGFloat = -20

class TSPizzaTableViewCell: TSFoodCategoryTableViewCell {
    
    //MARK: vars
    
    @IBOutlet weak var dynamicYConstraint: NSLayoutConstraint!
    @IBOutlet var cheeseImageViews: [TSMorfedView]!
    
    //MARK: funcs
    
    override func animate(offset offset: CGFloat) {
        guard offset >= 0 && offset <= 1 else { return }
        dynamicYConstraint.constant = kMinDynamicYConstant - offset * (dynamicImageView.frame.size.height * 0.05)
        dynamicXConstraint.constant = kMinDynamicXConstant + offset * 0.4 * dynamicImageView.frame.width
        for cheeseImageView in cheeseImageViews {
            cheeseImageView.morf(offset)
        }
    }

}
