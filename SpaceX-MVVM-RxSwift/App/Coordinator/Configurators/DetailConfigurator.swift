//
//  DetailConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import UIKit
import RxCocoa

protocol DetailConfiguratorType {
    func configure(
        networkService: NetworkServiceType,
        launch: LaunchesEntity,
        udService: UserDefaultsType,
        coordinator: AppCoodrinator
    ) -> UIViewController
}

final class DetailConfigurator: DetailConfiguratorType {
    func configure(
        networkService: NetworkServiceType,
        launch: LaunchesEntity,
        udService: UserDefaultsType,
        coordinator: AppCoodrinator
    ) -> UIViewController {
        let vm = DetailViewModel(
            networkSerivce: networkService,
            launchInfo: BehaviorRelay<LaunchesEntity>(value: launch),
            udService: udService
        )
        vm.coordinator = coordinator
        let vc = DetailViewController(viewModel: vm)
        return vc
    }
}
