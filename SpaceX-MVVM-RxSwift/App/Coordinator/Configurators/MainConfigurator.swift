//
//  MainConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit

protocol ConfiguratorType {
    func configure(networkService: NetworkServiceType,
                   coordinator: AppCoodrinator?) -> UIViewController
}

final class MainConfigurator: ConfiguratorType {
    func configure(networkService: NetworkServiceType,
                   coordinator: AppCoodrinator?) -> UIViewController {
        let vm = MainViewModel(
            networkingService: networkService,
            storage: LaunchesStorage(context: PersistenceController.shared.container.viewContext)
        )
        let vc = MainViewController(viewModel: vm)
        vm.coordinator = coordinator
        return vc
    }
}
