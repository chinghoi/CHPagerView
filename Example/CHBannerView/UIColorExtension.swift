//
//  UIColorExtension.swift
//  CHBannerView_Example
//
//  Created by chinghoi on 2020/8/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
    class var randomColor: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
