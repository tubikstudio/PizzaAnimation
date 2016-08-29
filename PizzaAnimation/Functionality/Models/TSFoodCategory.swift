//
//  TSDishItem.swift
//  PizzaAnimation
//
//  Created by Tubik Studio on 8/4/16.
//  Copyright © 2016 Tubik Studio. All rights reserved.
//

import UIKit

class TSFoodCategory {
    
    var title: String
    var staticImageName: String
    var dynamicImageName: String
    var color: UIColor
    var foodItems = [FoodItem]()
    
    init(title: String, staticImageName: String, dynamicImageName: String? = nil, color: UIColor) {
        self.title = title
        self.staticImageName = staticImageName
        self.color = color
        self.dynamicImageName = dynamicImageName == nil ? staticImageName + "_dynamic" : dynamicImageName!
    }
    
}

class FoodItem {
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
}