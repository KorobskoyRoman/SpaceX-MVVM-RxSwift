//
//  CoordinatorProtocol.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit

protocol Coordinator {
    func start()
    func performTransition(with type: Transition)
}

enum Transition {
    case perform(ViewControllers)
    case pop
}

enum ViewControllers {
    case main
    case detail(LaunchesEntity)
    case settings

    var viewController: UIViewController {
        switch self {
        case .main:
            let networkService = NetworkService()
            let viewModel = MainViewModel(networkingService: networkService, storage: LaunchesStorage(context: PersistenceController.shared.container.viewContext))
            return MainViewController(viewModel: viewModel)
        case .detail:
            let networkService = NetworkService()
            let viewModel = DetailViewModel(networkSerivce: networkService, launchInfo: nil)
            return DetailViewController(viewModel: viewModel)
        case .settings:
            let udService = UserDefaultsService()
            let viewModel = SettingsViewModel(udService: udService)
            let view = SettingsView(vm: viewModel)
            return SettingsViewController(viewModel: viewModel, mainView: view)
        }
    }
}
