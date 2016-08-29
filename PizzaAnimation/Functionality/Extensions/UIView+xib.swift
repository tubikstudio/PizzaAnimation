//
//  UIView+xib.swift
//  PizzaAnimation
//
//  Created by Tubik Studio on 8/4/16.
//  Copyright © 2016 Tubik Studio. All rights reserved.
//

import Foundation

import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    
    static func loadFromNib() -> Self {
        let nibName = String(Self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiateWithOwner(nil, options: nil).first as! Self
    }
    
}
