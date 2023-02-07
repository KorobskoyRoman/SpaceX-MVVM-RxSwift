//
//  NetworkService.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import RxSwift
import RxCocoa

protocol NetworkServiceType {
    func fetchLaunches() throws -> BehaviorRelay<[LaunchInfo]>
    func fetchRocket(id: String) throws -> BehaviorRelay<Rocket>
}

final class NetworkService: NetworkServiceType {
    private var launchesRelay = BehaviorRelay<[LaunchInfo]>(value: [])
    private let rocketRelay = BehaviorRelay<Rocket>(value: .emptyRocket)

    init() {
        do {
            launchesRelay = try fetchLaunches()
        } catch {
            print(error, "error init")
        }
    }

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
}

// MARK: - Launches
extension NetworkService {
    func fetchLaunches() throws -> BehaviorRelay<[LaunchInfo]> {
        let urlString = NetworkConstants.launchesUrl
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidUrl
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print(NetworkingError.noData.description)
                return
            }
            do {
                let launches = try self.parseJSON(type: [LaunchInfo].self, data: data)
                self.launchesRelay.accept(launches)
            } catch {
                print(error)
            }
        }
        .resume()

        return launchesRelay
    }
}

// MARK: - Rocket
extension NetworkService {
    func fetchRocket(id: String) throws -> BehaviorRelay<Rocket> {
        let urlString = NetworkConstants.rocketUrl + id
        guard let url = URL(string: urlString) else {
            return rocketRelay
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error, NetworkingError.unknown.description)
                return
            }
            guard let data = data else {
                print(NetworkingError.noData)
                return
            }
            do {
                let rocket = try self.parseJSON(type: Rocket.self, data: data)
                self.rocketRelay.accept(rocket)
            } catch {
                print(error)
            }
        }
        .resume()

        return rocketRelay
    }
}
