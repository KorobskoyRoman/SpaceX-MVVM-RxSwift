//
//  NetworkingError.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.02.2023.
//

import Foundation

enum NetworkingError: Error {
    case unknown
    case invalidUrl
    case noData

    var description: String {
        switch self {
        case .unknown:
            return "Unknown error occured!"
        case .invalidUrl:
            return "Invalid url"
        case .noData:
            return "No data fetched"
        }
    }
}
