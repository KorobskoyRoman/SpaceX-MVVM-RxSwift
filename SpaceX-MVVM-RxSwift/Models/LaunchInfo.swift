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
struct Rocket: Decodable, Hashable {
    let flickrImages: [String]?
    let name, type: String?
    let id: String?
    let country: String
    let costPerLaunch: Int
    let height, diameter: Diameter
    let mass: Mass
    let successRatePct: Int

    enum CodingKeys: String, CodingKey {
        case height, diameter, mass
        case flickrImages = "flickr_images"
        case costPerLaunch = "cost_per_launch"
        case name, type, id, country
        case successRatePct = "success_rate_pct"
    }

    static func == (lhs: Rocket, rhs: Rocket) -> Bool {
        return lhs.id == rhs.id
    }
}


struct Diameter: Decodable, Hashable {
    let meters, feet: Double
}

struct Mass: Decodable, Hashable {
    let kg, lb: Int
}

extension Rocket {
    static var emptyRocket: Rocket {
        return Rocket(flickrImages: [],
                      name: "",
                      type: "",
                      id: "",
                      country: "",
                      costPerLaunch: 0,
                      height: Diameter(meters: 0, feet: 0),
                      diameter: Diameter(meters: 0, feet: 0),
                      mass: Mass(kg: 0, lb: 0),
                      successRatePct: 0)
    }
}
