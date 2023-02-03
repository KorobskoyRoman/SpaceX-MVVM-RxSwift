//
//  NetworkService.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import Foundation

final class NetworkService {
    func fetchLaunches(completion: @escaping ([LaunchInfo]) -> Void) {
        let urlString = NetworkConstants.launchesUrl

        guard let urlString = URL(string: urlString) else { return }

        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: urlString) {  data, response, error in
            guard let data = data else { return }
            if let fetchData = self.parseJSON(type: [LaunchInfo].self, data: data) {
                completion(fetchData)
            }
        }
        task.resume()
    }

    func fetchRocket(id: String, completion: @escaping (Rocket) -> Void) {
        let urlString = NetworkConstants.rocketUrl + id

        guard let urlString = URL(string: urlString) else { return }

        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: urlString) {  data, response, error in
            guard let data = data else { return }
            if let fetchData = self.parseJSON(type: Rocket.self, data: data) {
                completion(fetchData)
            }
        }
        task.resume()
    }

    private func parseJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let data = data else {
            return nil
        }
        do {
            let parseData = try decoder.decode(T.self, from: data)
            return parseData
        } catch let jsonError {
            print("error pasring json: \(jsonError)")
            return nil
        }
    }
}
