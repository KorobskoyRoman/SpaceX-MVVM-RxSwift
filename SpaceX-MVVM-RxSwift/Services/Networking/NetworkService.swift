//
//  NetworkService.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import RxSwift
import RxCocoa
import Foundation

protocol NetworkServiceType {
    func fetchLaunches() async throws -> BehaviorRelay<[LaunchInfo]>
    func fetchRocket(id: String) async throws -> Rocket
}

final class NetworkService: NetworkServiceType {
    private let launchesRelay = BehaviorRelay<[LaunchInfo]>(value: [])
    private let rocketRelay = BehaviorRelay<Rocket>(value: .emptyRocket)

    private func parseJSON<T: Decodable>(type: T.Type, data: Data?) throws -> T {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        guard let data = data else {
            throw NetworkingError.noData
        }
        return try decoder.decode(T.self, from: data)
    }

    private func checkResponse(_ response: URLResponse) throws -> Bool {
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkingError.invalidUrl
        }
        return true
    }
}

// MARK: - Launches
extension NetworkService {
    func fetchLaunches() async throws -> BehaviorRelay<[LaunchInfo]> {
        let urlString = NetworkConstants.launchesUrl
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidUrl
        }

        let (data, response) = try await URLSession.shared.data(
            from: url
        )

        guard try checkResponse(response) else { throw NetworkingError.invalidResponse }

        let launches = try parseJSON(type: [LaunchInfo].self, data: data)
        launchesRelay.accept(launches)

        return launchesRelay
    }
}

// MARK: - Rocket
extension NetworkService {
    func fetchRocket(id: String) async throws -> Rocket {
        let url = URL(string: NetworkConstants.rocketUrl + id)

        guard let url else {
            throw NetworkingError.invalidUrl
        }

        let (data, response) = try await URLSession.shared.data(
            from: url
        )

        guard try checkResponse(response) else { throw NetworkingError.invalidResponse }

        let rocket = try parseJSON(type: Rocket.self, data: data)
        return rocket
    }
}
