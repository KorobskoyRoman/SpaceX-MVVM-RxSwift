//
//  NavigationCoordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import UIKit

class NavigationCoordinator: Coordinator<UINavigationController> {

    func set(
        _ viewControllers: [UIViewController],
        animated: Bool = true
    ) {
        container.setViewControllers(viewControllers, animated: animated)
    }

    func push(
        _ viewController: UIViewController,
        animated: Bool = true
    ) {
        container.pushViewController(viewController, animated: animated)
    }

    func present(
        _ viewController: UIViewController,
        style: UIModalPresentationStyle? = nil,
        animated: Bool = true
    ) {
        if let style = style {
            viewController.modalPresentationStyle = style
        }
        container.present(viewController, animated: animated)
    }

    func dismiss(animated: Bool = true) {
        container.dismiss(animated: animated)
    }

    func pop(animated: Bool = true) {
        container.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        container.popToRootViewController(animated: animated)
    }
}
