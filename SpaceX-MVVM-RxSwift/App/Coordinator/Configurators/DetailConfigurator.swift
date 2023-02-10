//
//  DetailConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import UIKit
import RxCocoa

protocol DetailConfiguratorType {
    func configure(networkService: NetworkServiceType,
//                   launch: LaunchInfo) -> UIViewController
                   launch: LaunchesEntity) -> UIViewController
}

final class DetailConfigurator: DetailConfiguratorType {
    func configure(networkService: NetworkServiceType,
//                   launch: LaunchInfo) -> UIViewController {
                   launch: LaunchesEntity) -> UIViewController {
        let vm = DetailViewModel(networkSerivce: networkService,
//                                 launchInfo: BehaviorRelay<LaunchInfo>(value: launch))
                                 launchInfo: BehaviorRelay<LaunchesEntity>(value: launch))
        let vc = DetailViewController(viewModel: vm)
        return vc
    }
}
