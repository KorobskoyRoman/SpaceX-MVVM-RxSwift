//
//  MainConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit

protocol ConfiguratorType {
    func configure(networkService: NetworkService) -> UIViewController
}

final class MainConfigurator: ConfiguratorType {
    func configure(networkService: NetworkService) -> UIViewController {
        let vm = MainViewModel(networkingService: networkService)
        let vc = MainViewController(viewModel: vm)
        return vc
    }
}
