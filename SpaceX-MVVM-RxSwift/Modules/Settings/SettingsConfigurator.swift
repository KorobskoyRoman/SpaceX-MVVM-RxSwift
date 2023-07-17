//
//  SettingsConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 15.07.2023.
//

import UIKit

final class SettingsConfigurator {

    typealias Module = (
        view: UIViewController,
        viewModel: SettingsModuleType
    )

    class func configure() -> Module {
        let view = SettingsViewController()
        let viewModel = SettingsViewModel(
            dependencies: .init(udService: AppContainer.shared.inject())
        )
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
