//
//  SplashViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import UIKit

final class SplashViewController : RxBaseViewController<SplashView> {
    
    var viewModel: SplashViewModelType!

    private let image: UIImageView = {
        return UIImageViewBuilder()
            .contentMode(.scaleAspectFit)
            .build()
    }()

    private lazy var animationContainer = InfoAlert()

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
        setupNav()
    }

    // MARK: Configure

    private func configure(_ commands: SplashViewModel.Commands) {

    }

    private func configure(_ bindings: SplashViewModel.Bindings) {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.bindings.getLaunches.accept(())
    }

    override func viewDidAppear(_ animated: Bool) {
        //        viewModel.stopNotify()
        super.viewDidAppear(animated)
        viewModel.commands.viewDidAppear.accept(())
    }

    private func setupNav() {
        navigationController?.navigationBar.isHidden = true
    }
}
