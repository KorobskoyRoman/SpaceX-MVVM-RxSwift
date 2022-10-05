//
//  Constants.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import UIKit

enum MainConstants {
    static let mainTitle = "SpaceX Launches"
}

enum NetworkConstants {
    static let launchesUrl = "https://api.spacexdata.com/v4/launches"
    static let rocketUrl = "https://api.spacexdata.com/v4/rockets/"
}

enum HelpConstants {
    static let title = "SpaceX Launches"

    enum Constraints {
        static let cellWidth: CGFloat = 174
        static let cellHeight: CGFloat = 160

        static let itemInset: CGFloat = 9
        static let topItemInset: CGFloat = UIDevice.current.name.contains("Max") ? 0 : 9
        static let groupSize = 2
        static let interGroupSpacing: CGFloat = 5
        static let interSectionSpacing: CGFloat = 20

        static let defaultNavBarHeight: CGFloat = 44.0
    }
}

enum ViewConstants {
    static let loadingText = "Загрузка..."
}

enum Insets {
    static let inset10: CGFloat = 10
    static let inset70: CGFloat = 70
}
