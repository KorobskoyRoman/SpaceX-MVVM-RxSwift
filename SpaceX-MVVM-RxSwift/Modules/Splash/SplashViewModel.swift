//
//  SplashViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import Foundation

protocol SplashViewModelType {
    func push()
}

final class SplashViewModel: SplashViewModelType {
    weak var coordinator: AppCoodrinator?
    
    func push() {
        coordinator?.performTransition(with: .perform(.main))
    }
}
