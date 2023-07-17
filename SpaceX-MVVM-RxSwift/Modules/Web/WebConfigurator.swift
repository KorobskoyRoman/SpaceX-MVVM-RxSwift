//
//  WebConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 18.02.2023.
//

import UIKit

final class WebConfigurator {
    typealias Module = (
        view: UIViewController,
        viewModel: WebModuleType
    )

    class func configure() -> Module {
        let view = WebViewController()
        let viewModel = WebViewModel()
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
