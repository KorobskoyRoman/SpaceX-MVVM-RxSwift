//
//  SplashConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import UIKit

final class SplashConfigurator {

    typealias Module = (
        view: UIViewController,
        viewModel: SplashViewModelType
    )

    func configure() -> Module {
        let view = SplashViewController()
        let viewModel = SplashViewModel(
            dependencies: .init(
                networkingService: AppContainer.shared.inject(),
                storage: AppContainer.shared.inject()
            )
        )
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
