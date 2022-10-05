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
        navController.navigationBar.standardAppearance = configureNavBarAppearence()
        navController.navigationBar.compactAppearance = configureNavBarAppearence()
        navController.navigationBar.scrollEdgeAppearance = configureNavBarAppearence()
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

extension AppCoodrinator {
    private func configureNavBarAppearence() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .purple
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.navBarTitle]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.navBarLargeTitle]

        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)

        appearance.backButtonAppearance = backButtonAppearance
        UINavigationBar.appearance().tintColor = .white

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        return appearance
    }
}
