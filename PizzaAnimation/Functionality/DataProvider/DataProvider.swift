//
//  DataProvider.swift
//  PizzaAnimation
//
//  Created by Tubik Studio on 8/5/16.
//  Copyright © 2016 Tubik Studio. All rights reserved.
//

import UIKit

class DataProvider {
    
    func mockedCategories() -> [TSFoodCategory] {
        let pasta = TSFoodCategory(title: NSLocalizedString("P A S T A", comment: ""),
                                   staticImageName: "pasta",
                                   color: UIColor(red: 0.26, green: 0.85, blue: 0.52, alpha: 1.0))
        pasta.foodItems = [FoodItem(title:"TURBO RIGATONI ARRABBIATA"),
                           FoodItem(title:"SPAGHETTI CARBONARA"),
                           FoodItem(title:"FRESH CRAB SPAGHETTI"),
                           FoodItem(title:"SQUID & MUSSEL SPAGHETTI NERO")]
        
        let pizza = TSFoodCategory(title: NSLocalizedString("P I Z Z A", comment: ""),
                                   staticImageName: "pizza",
                                   color: UIColor(red: 0.89, green: 0.3, blue: 0.3, alpha: 1.0))
        pizza.foodItems = [FoodItem(title:"PIZZA AGILO E OLIO"),
                           FoodItem(title:"PIZZA ALLA MARINARA"),
                           FoodItem(title:"PIZZA CON LE COZZE"),
                           FoodItem(title:"PIZZA ALLE VONGOLE"),
                           FoodItem(title:"PIZZA MARGHERITA"),
                           FoodItem(title:"PIZZA REGINA")]
        
        let potatoes = TSFoodCategory(title: NSLocalizedString("P O T A T O E S", comment: ""),
                                      staticImageName: "potatoes",
                                      color: UIColor(red: 1.0, green: 0.7, blue: 0.29, alpha: 1.0))
        potatoes.foodItems = [FoodItem(title:"MASHED POTATOES"),
                           FoodItem(title:"SCALLOPED POTATOES"),
                           FoodItem(title:"POTATO SOUP"),
                           FoodItem(title:"SPICE SWEET POTATOES")]
        
        let salads = TSFoodCategory(title: NSLocalizedString("S A L A D S", comment: ""),
                                    staticImageName: "salads",
                                    color: UIColor(red: 0.79, green: 0.46, blue: 0.73, alpha: 1.0))
        salads.foodItems = [FoodItem(title:"TOSSED GREEN SALAD"),
                              FoodItem(title:"CAESAR SALAD"),
                              FoodItem(title:"FRESH VEGETABLE SALAD"),
                              FoodItem(title:"FACTORY CHOPPED SALAD"),
                              FoodItem(title:"CHINESE CHICKEN SALAD"),
                              FoodItem(title:"LUAU SALAD"),
                              FoodItem(title:"GRILLED CHICKEN TOSTADA SALAD")]
        return [potatoes, pasta, pizza, salads]
    }
    
}