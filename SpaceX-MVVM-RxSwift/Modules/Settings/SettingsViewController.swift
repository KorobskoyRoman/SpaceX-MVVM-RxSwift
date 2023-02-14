//
//  SettingsViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 13.02.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModelType
    private let mainView: SettingsView

    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUDStates()
    }

    init(viewModel: SettingsViewModelType,
         mainView: SettingsView) {
        self.viewModel = viewModel
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
