//
//  ReachabilityError.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 24.02.2023.
//

enum ReachabilityError {
    case unavailable
    case changedToUnavailable

    var description: String {
        switch self {
        case .unavailable:
            return "Network is unavailable!"
        case .changedToUnavailable:
            return "Seems like network is unavailable!"
        }
    }
}
