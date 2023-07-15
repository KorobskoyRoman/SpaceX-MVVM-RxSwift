//
//  SettingsViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 13.02.2023.
//

import UIKit

final class SettingsViewController: RxBaseViewController<SettingsView> {

    var viewModel: SettingsViewModelType!

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    private func configure(_ commands: SettingsViewModel.Commands) {

    }

    private func configure(_ bindings: SettingsViewModel.Bindings) {
        bindings.height.bind(to: contentView.height).disposed(by: bag)
        bindings.diameter.bind(to: contentView.diameter).disposed(by: bag)
        bindings.mass.bind(to: contentView.mass).disposed(by: bag)
        bindings.weight.bind(to: contentView.weight).disposed(by: bag)

        contentView.saveHeightState.bind(to: viewModel.commands.updateHeightState).disposed(by: bag)
        contentView.saveDiameterState.bind(to: viewModel.commands.updateDiameterState).disposed(by: bag)
        contentView.saveMassState.bind(to: viewModel.commands.updateMassState).disposed(by: bag)
        contentView.saveWeightState.bind(to: viewModel.commands.updateWeightState).disposed(by: bag)
    }
}
