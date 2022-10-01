//
//  AppCoordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import Foundation
import UIKit

protocol AppCoordinatorType {
    func start()
}

final class AppCoodrinator: AppCoordinatorType {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewController = MainViewController()
        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
