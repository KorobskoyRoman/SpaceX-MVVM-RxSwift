//
//  DetailConfigurator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import UIKit
import RxCocoa

protocol DetailConfiguratorType {
    func configure(networkService: NetworkService,
                   launch: LaunchInfo) -> UIViewController
}

final class DetailConfigurator: DetailConfiguratorType {
    func configure(networkService: NetworkService,
                   launch: LaunchInfo) -> UIViewController {
        let vm = DetailViewModel(networkSerivce: networkService,
                                 launchInfo: BehaviorRelay<LaunchInfo>(value: launch))
//        vm.launchInfo = BehaviorRelay<LaunchInfo>(value: launch)
        let vc = DetailViewController(viewModel: vm)
        return vc
    }
}
