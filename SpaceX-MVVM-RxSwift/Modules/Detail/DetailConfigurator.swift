//
//  DetailConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import UIKit

final class DetailConfigurator {

    typealias Module = (
        view: UIViewController,
        viewModel: DetailModuleType
    )

    class func configure() -> Module {
        let view = DetailViewController()
        let viewModel = DetailViewModel(
            dependencies: .init(
                networkingService: AppContainer.shared.inject(),
                udService: AppContainer.shared.inject()
            )
        )
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
