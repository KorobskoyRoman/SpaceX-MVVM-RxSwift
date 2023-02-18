//
//  WebConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 18.02.2023.
//

import UIKit

protocol WebConfiguratorType {
    func configure(
        link: String
    ) -> UIViewController
}

final class WebConfigurator: WebConfiguratorType {
    func configure(
        link: String
    ) -> UIViewController {
        let vm = WebViewModel(link: link)
        let vc = WebViewController(viewModel: vm)

        return vc
    }
}
