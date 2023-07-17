//
//  MainConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit

final class MainConfigurator {

    typealias Module = (
        view: UIViewController,
        viewModel: MainModuleType
    )

    class func configure() -> Module {
        let view = MainViewController()
        let viewModel = MainViewModel(
            dependencies: .init(
                networkingService: AppContainer.shared.inject(),
                storageService: AppContainer.shared.inject()
            )
        )
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
