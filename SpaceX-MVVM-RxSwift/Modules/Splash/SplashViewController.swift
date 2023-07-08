//
//  SplashViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import UIKit

final class SplashViewController : RxBaseViewController<SplashView> {
    
    var viewModel: SplashViewModelType!

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
        setupNav()
    }

    // MARK: Configure

    private func configure(_ commands: SplashViewModel.Commands) {

    }

    private func configure(_ bindings: SplashViewModel.Bindings) {
        bindings.hasError.bind(to: contentView.animationContainer.rx.isHidden).disposed(by: bag)
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.bindings.getLaunches.accept(())
        viewModel.bindings.startNotify.accept(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.commands.viewDidAppear.accept(())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.bindings.stopNotyfy.accept(())
    }

    // MARK: - Private

    private func setupNav() {
        navigationController?.navigationBar.isHidden = true
    }
}
