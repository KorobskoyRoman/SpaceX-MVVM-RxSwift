//
//  ViewControllerCoordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import UIKit

class ViewControllerCoordinator: Coordinator<UIViewController> {

    func addSubview(_ view: UIView) {
        container.view.addSubview(view)
    }

    func add(_ child: UIViewController, frame: CGRect? = nil) {
        container.addChild(child)
        if let frame = frame {
            child.view.frame = frame
        }
        container.view.addSubview(child.view)
        child.didMove(toParent: container)
    }

    func remove(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }

    func present(_ viewController: UIViewController, style: UIModalPresentationStyle? = nil, animated: Bool = true) {
        if let style = style {
            viewController.modalPresentationStyle = style
        }
        container.present(viewController, animated: animated)
    }
}
