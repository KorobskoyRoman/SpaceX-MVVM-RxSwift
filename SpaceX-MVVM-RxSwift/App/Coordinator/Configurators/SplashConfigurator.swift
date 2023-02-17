//
//  SplashConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import UIKit

protocol SplashConfiguratorType {
    func configure(
        networkService: NetworkServiceType,
        coordinator: AppCoodrinator
    ) -> UIViewController
}

final class SplashConfigurator: SplashConfiguratorType {
    func configure(
        networkService: NetworkServiceType,
        coordinator: AppCoodrinator
    ) -> UIViewController {
        let vm = SplashViewModel(networkingService: networkService, storage: LaunchesStorage(context: PersistenceController.shared.container.viewContext))
        vm.coordinator = coordinator
        let vc = SplashViewController(viewModel: vm)
        
        return vc
    }
}
