//
//  MainCoordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.07.2023.
//

import RxSwift
import UIKit
import RxRelay

final class MainCoordinator: NavigationCoordinator {

    struct Input {
        var detailsModel = BehaviorRelay<LaunchesEntity?>(value: nil)
    }

    let input = Input()

    private let bag = DisposeBag()

    override func start() {
        let module = MainConfigurator.configure()
        set([module.view])
    }
}
