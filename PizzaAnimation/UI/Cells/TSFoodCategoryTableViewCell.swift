//
//  TSDishTableViewCell.swift
//  PizzaAnimation
//
//  Created by Tubik Studio on 8/4/16.
//  Copyright © 2016 Tubik Studio. All rights reserved.
//

import UIKit

let kActionButtonHeight: CGFloat = 64

protocol TSFoodCategoryTableViewCellDelegate: class {
    
    func foodCategoryTableViewCellDidPressActionButton(cell: TSFoodCategoryTableViewCell)
    func foodCategoryTableViewCellDidPressCloseButton(cell: TSFoodCategoryTableViewCell)
    
}

class TSFoodCategoryTableViewCell: UITableViewCell {
    
    //MARK: vars
    
    @IBOutlet weak var staticImageView: UIImageView!
    @IBOutlet weak var dynamicImageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dynamicXConstraint: NSLayoutConstraint!
    
    weak var delegate: TSFoodCategoryTableViewCellDelegate?
    
    private var coverWidth: CGFloat = 0
    
    //MARK: actions
    
    @IBAction func actionButttonPressed(sender: AnyObject) {
        delegate?.foodCategoryTableViewCellDidPressActionButton(self)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        delegate?.foodCategoryTableViewCellDidPressCloseButton(self)
    }
    
    //MARK: funcs
    
    func customizeCell(withCategory category: TSFoodCategory, coverWidth: CGFloat = 20) {
        button.setTitle(category.title, forState: .Normal)
        button.setTitle(category.title, forState: .Highlighted)
        button.backgroundColor = category.color
        staticImageView.image = UIImage(named: category.staticImageName)
        dynamicImageView.image = UIImage(named: category.dynamicImageName)
        self.coverWidth = coverWidth
    }
    
    func animate(offset offset: CGFloat) {
        guard offset >= 0 && offset <= 1 else { return }
        
        if let dynamicImage = dynamicImageView.image, staticImage = staticImageView.image {
            var minX = (dynamicImage.size.width - frame.width)/2.0
            var maxX = staticImageView.center.x - (staticImage.size.width + dynamicImage.size.width + frame.width)/2.0 + coverWidth
            if maxX < minX {
                swap(&maxX, &minX)
            }
            let xOffset = (offset) * (maxX - minX) + minX
            dynamicXConstraint.constant = xOffset
        }
    }
   
}
