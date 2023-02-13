//
//  UIColor+.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import UIKit

extension UIColor {
    static func mainBackground() -> UIColor {
        return #colorLiteral(red: 0.937254902, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
    }

    static func shimmerBackground() -> UIColor {
        return UIColor(white: 0.85, alpha: 1.0)
    }

    static func shimmerSecondary() -> UIColor {
        return UIColor(white: 0.95, alpha: 1.0)
    }
}
