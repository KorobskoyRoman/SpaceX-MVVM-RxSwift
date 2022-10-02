//
//  CoordinatorProtocol.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit

protocol Coordinator {
    var networkService: NetworkService { get set }

    func start()
    func performTransition(with type: Transition)
}

enum Transition {
    case perform(ViewControllers)
    case pop
}

enum ViewControllers {
    case main

    var viewController: UIViewController {
        switch self {
        case .main:
            let viewModel = MainViewModel(networkingService: NetworkService())
            return MainViewController(viewModel: viewModel)
        }
    }
}
