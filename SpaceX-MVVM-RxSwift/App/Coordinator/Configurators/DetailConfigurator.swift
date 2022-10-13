//
//  DetailConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import UIKit

protocol DetailConfiguratorType {
    func configure() -> UIViewController
}

final class DetailConfigurator: DetailConfiguratorType {
    func configure() -> UIViewController {
        let vm = DetailViewModel()
        let vc = DetailViewController(viewModel: vm)
        return vc
    }
}
