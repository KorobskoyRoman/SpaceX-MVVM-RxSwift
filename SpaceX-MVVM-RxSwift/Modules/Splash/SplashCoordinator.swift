//
//  SplashCoordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import UIKit
import RxSwift
import RxRelay

final class SplashCoordinator: NavigationCoordinator {

    struct Output {
        let done = PublishRelay<Void>()
    }

    let output = Output()

    private let bag = DisposeBag()

    override func start() {
        let module = SplashConfigurator().configure()
        set([module.view])
        Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(finishModule),
            userInfo: nil,
            repeats: false
        )
        setupBindings()
    }

    private func setupBindings() {
        output.done.bind(to: Binder<Void>(self) { target, _ in
            target.startMainScreen()
        }).disposed(by: bag)
    }

    @objc func finishModule() {
        output.done.accept(())
    }
}

private extension SplashCoordinator {
    // TODO: Setup main screen
    func startMainScreen() {
//        let module = UIViewController()
        let module = MainConfigurator.configure()

        push(module.view)
    }
}
