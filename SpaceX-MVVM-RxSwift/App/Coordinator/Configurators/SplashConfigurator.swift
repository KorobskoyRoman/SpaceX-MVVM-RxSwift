//
//  SplashConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import UIKit

protocol SplashConfiguratorType {
    func configure(
        coordinator: AppCoodrinator
    ) -> UIViewController
}

final class SplashConfigurator: SplashConfiguratorType {
    func configure(coordinator: AppCoodrinator) -> UIViewController {
        let vm = SplashViewModel()
        vm.coordinator = coordinator
        let vc = SplashViewController(viewModel: vm)
        
        return vc
    }
}
