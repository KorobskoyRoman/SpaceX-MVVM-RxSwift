//
//  AppCoodinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import UIKit
import RxSwift

class AppCoodinator: Coordinator<UIWindow> {

    private let bag = DisposeBag()

    override func start() {
        configure()
    }

    private func configure() {
        let navigationController = UINavigationController()
        let coordinator = SplashCoordinator(container: navigationController)

        coordinator.output.done.bind(to: Binder<Void>(self) { [unowned coordinator] target, _ in
            target.startLaunchCoordinator()
            target.removeChild(coordinator)
        }).disposed(by: bag)
        addChild(coordinator)
        setRoot(viewController: navigationController)
        container.overrideUserInterfaceStyle = .light
        coordinator.start()
    }

    func startLaunchCoordinator() {
        let navigationController = UINavigationController()
        let coordinator = SplashCoordinator(container: navigationController)

        addChild(coordinator)
        setRoot(viewController: navigationController)
        container.overrideUserInterfaceStyle = .light
        coordinator.start()
    }

    func setRoot(viewController: UIViewController) {
        container.rootViewController = viewController
    }
}
