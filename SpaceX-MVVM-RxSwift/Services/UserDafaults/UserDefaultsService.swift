//
//  UserDefaultsService.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 13.02.2023.
//

import Foundation

protocol UserDefaultsType {
    func save(for type: UserDefaultsKeys)
    func getObject(with type: UserDefaultsKeys) -> Bool
}

final class UserDefaultsService: UserDefaultsType {
    private let userDefaults = UserDefaults.standard

    func save(for type: UserDefaultsKeys) {
        var oldValue = getObj(for: type.rawValue)

        oldValue.toggle()
        userDefaults.set(oldValue, forKey: type.rawValue)
    }

    func getObject(with type: UserDefaultsKeys) -> Bool {
        return getObj(for: type.rawValue)
    }

    private func getObj(for key: String) -> Bool {
        return userDefaults.object(forKey: key) as? Bool ?? false
    }
}
