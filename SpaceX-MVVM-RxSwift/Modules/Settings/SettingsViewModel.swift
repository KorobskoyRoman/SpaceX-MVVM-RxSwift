//
//  SettingsViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 13.02.2023.
//

import Foundation

protocol SettingsViewModelType {
    var heightState: Bool { get set }
    var diameterState: Bool { get set }
    var massState: Bool { get set }
    var weightState: Bool { get set }
    func save(for type: UserDefaultsKeys)
    func getUDStates()
}

final class SettingsViewModel: SettingsViewModelType {
    var heightState: Bool = false
    var diameterState: Bool = false
    var massState: Bool = false
    var weightState: Bool = false

    private let udService: UserDefaultsType

    init(udService: UserDefaultsType) {
        self.udService = udService
        getUDStates()
    }

    func save(for type: UserDefaultsKeys) {
        udService.save(for: type)
    }

    func getUDStates() {
        heightState = udService.getObject(with: .height)
        diameterState = udService.getObject(with: .diameter)
        massState = udService.getObject(with: .mass)
        weightState = udService.getObject(with: .weight)
    }
}
