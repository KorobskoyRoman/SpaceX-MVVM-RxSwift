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
        module.viewModel.moduleBindings.startDetails
            .filterNil()
            .do(onNext: { value in
                self.input.detailsModel.accept(value)
            }).bind(to: Binder<LaunchesEntity?>(self) { target, _ in
                target.startDetailsScreen()
            }).disposed(by: bag)
        set([module.view])
    }
}

private extension MainCoordinator {

    func startDetailsScreen() {
        let module = DetailConfigurator.configure()

        input.detailsModel.bind(to: module.viewModel.moduleBindings.launch).disposed(by: bag)
        module.viewModel.moduleBindings.loadRocketInfo.accept(())

        push(module.view)
    }
}
