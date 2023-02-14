//
//  AppCoordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import Foundation
import UIKit

final class AppCoodrinator: Coordinator {
    private var networkService: NetworkServiceType
    private var udService: UserDefaultsType
    private let window: UIWindow
    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
        self.networkService = NetworkService()
        self.udService = UserDefaultsService()
    }

    func start() {
        let viewController = getViewControllerByType(type: .main)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.navigationBar.standardAppearance = configureNavBarAppearence()
        navigationController?.navigationBar.compactAppearance = configureNavBarAppearence()
        navigationController?.navigationBar.scrollEdgeAppearance = configureNavBarAppearence()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func getViewControllerByType(type: ViewControllers) -> UIViewController {
        var viewController: UIViewController

        switch type {
        case .main:
            let config = MainConfigurator()
            viewController = config.configure(networkService: networkService,
                                              coordinator: self)
            return viewController
        case .detail(let launch):
            let config = DetailConfigurator()
            viewController = config.configure(
                networkService: networkService,
                launch: launch,
                udService: udService
            )
            return viewController
        case .settings:
            let udService = UserDefaultsService()
            let vm = SettingsViewModel(udService: udService)
            let view = SettingsView(vm: vm)
            viewController = SettingsViewController(viewModel: vm, mainView: view)
            return viewController
        }
    }

    func performTransition(with type: Transition) {
        switch type {
        case .perform(let vc):
            let viewController = getViewControllerByType(type: vc)
            navigationController?.pushViewController(viewController, animated: true)
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
