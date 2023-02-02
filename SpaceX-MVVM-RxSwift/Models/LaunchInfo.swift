//
//  LaunchInfo.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import Foundation

struct LaunchInfo: Decodable, Hashable {
    var uuid = UUID()
    let links: Links
    let rocket: String?
    let success: Bool?
    let details: String?
    let name: String?
    let dateUTC: Date

    enum CodingKeys: String, CodingKey {
        case links, rocket, success, details, name
        case dateUTC = "date_utc"
    }

    static func == (lhs: LaunchInfo, rhs: LaunchInfo) -> Bool {
        lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Links: Decodable {
    let patch: Patch
    let webcast: String?
    let article: String?
}

struct Patch: Decodable {
    let small: String?
}

// MARK: - Rockets
struct Rocket: Decodable {
    let height, diameter: Size
    let mass: Mass
    let payloadWeights: [PayloadWeight]
    let flickrImages: [String]?
    let name, type: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case flickrImages = "flickr_images"
        case payloadWeights = "payload_weights"
        case name, type, id, height, diameter, mass
    }
}

struct Size: Decodable {
    let meters, feet: Double?
}

struct Mass: Decodable {
    let kg, lb: Double
}

struct PayloadWeight: Decodable {
    let id, name: String
    let kg, lb: Double
}

extension Rocket {
    static var emptyRocket: Rocket {
        Rocket(
            height: Size(meters: 0, feet: 0),
            diameter: Size(meters: 0, feet: 0),
            mass: Mass(kg: 0, lb: 0),
            payloadWeights: [
                PayloadWeight(
                    id: "",
                    name: "",
                    kg: 0,
                    lb: 0
                )
            ],
            flickrImages: [],
            name: "",
            type: "",
            id: ""
        )
    }
}
