//
//  UIFont+.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit

extension UIFont {
    class var navBarTitle: UIFont {
        return UIFont.systemFont(ofSize: 21.0, weight: .bold)
    }

    class var navBarLargeTitle: UIFont {
        return UIFont.systemFont(ofSize: 35.0, weight: .bold)
    }

    class var lab14: UIFont {
        return UIFont(name: "LabGrotesque-Regular", size: 14) ?? navBarTitle
    }

    class var lab24: UIFont {
        return UIFont(name: "LabGrotesque-Medium", size: 24) ?? navBarLargeTitle
    }
}
