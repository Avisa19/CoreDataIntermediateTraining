//
//  Extensions.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 14/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
