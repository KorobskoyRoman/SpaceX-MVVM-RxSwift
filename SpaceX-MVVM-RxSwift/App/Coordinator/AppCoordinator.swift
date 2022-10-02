//
//  AppCoordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import Foundation
import UIKit

final class AppCoodrinator: Coordinator {
    private let window: UIWindow
    var networkService = NetworkService()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewController = getViewControllerByType(type: .main)
        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

    private func getViewControllerByType(type: ViewControllers) -> UIViewController {
        var viewController: UIViewController

        switch type {
        case .main:
            let config = MainConfigurator()
            viewController = config.configure(networkService: networkService)
            return viewController
        }
    }

    func performTransition(with type: Transition) {
        switch type {
        case .perform(let vc):
            let viewControleller = getViewControllerByType(type: vc)
            viewControleller.navigationController?.pushViewController(viewControleller, animated: true)
        case .pop:
            UINavigationController().popViewController(animated: true)
        }
    }
}
