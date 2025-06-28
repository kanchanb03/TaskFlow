//
//  UIColor+Dynamic.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/17/25.
//

import UIKit

extension UIColor {
    /// Light blue (#F0F8FF) in Light Mode, Black in Dark Mode.
    static var dynamicBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .black
            default:
                // #F0F8FF
                return UIColor(
                    red: 240.0/255.0,
                    green: 248.0/255.0,
                    blue: 255.0/255.0,
                    alpha: 1.0
                )
            }
        }
    }
    
    /// Gold (#FFD401) in Light Mode, White in Dark Mode.
    static var dynamicHeading: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white
            default:
                // #FFD401
                return UIColor(
                    red: 255.0/255.0,
                    green: 212.0/255.0,
                    blue: 1.0/255.0,
                    alpha: 1.0
                )
            }
        }
    }
    
    /// Black in Light Mode, White in Dark Mode.
    static var dynamicBody: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
    }
}
