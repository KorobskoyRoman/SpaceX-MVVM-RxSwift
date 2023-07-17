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
        var link = BehaviorRelay<String?>(value: nil)
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

        module.viewModel.moduleBindings.startSettings
            .bind(to: Binder(self) { target, _ in
                target.startSettingsScreen()
            }).disposed(by: bag)

        set([module.view])
    }
}

private extension MainCoordinator {

    func startDetailsScreen() {
        let module = DetailConfigurator.configure()

        input.detailsModel.bind(to: module.viewModel.moduleBindings.launch).disposed(by: bag)
        module.viewModel.moduleBindings.loadRocketInfo.accept(())

        module.viewModel.moduleBindings.startWeb
            .filterNil()
            .do(onNext: { value in
                self.input.link.accept(value)
            })
            .bind(to: Binder(self) { target, _ in
                target.startWebScreen()
            }).disposed(by: bag)

        push(module.view)
    }

    func startSettingsScreen() {
        let module = SettingsConfigurator.configure()

        module.viewModel.moduleCommands.getData.accept(())
        present(module.view, style: .formSheet)
    }

    func startWebScreen() {
        let module = WebConfigurator.configure()

        input.link.bind(to: module.viewModel.moduleBindings.link).disposed(by: bag)

        push(module.view)
    }
}
