//
//  UIClorExtasionForSupportDarkTheme.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 19.03.2021.
//
import UIKit

extension UIColor {
    
    static func myColorFor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            let theme = UIApplication.shared.windows.first?.traitCollection.userInterfaceStyle
            if theme == .dark {
                return dark
            } else {
                return light
            }
            
        } else {
            return light
        }
    }

}
