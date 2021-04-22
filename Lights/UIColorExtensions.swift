//
//  UIColorExtensions.swift
//  Lights
//
//  Created by Jan Gulkowski on 23/04/2021.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        let color = UIColor(red: .random(in: 0...1),
                            green: .random(in: 0...1),
                            blue: .random(in: 0...1),
                            alpha: 1.0)
        return color
    }
}
