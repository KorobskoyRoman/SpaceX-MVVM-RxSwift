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
    let dateUTC: Date?

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
    let flickrImages: [String]?
    let name, type: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case flickrImages = "flickr_images"
        case name, type, id
    }
}

extension Rocket {
    static var emptyRocket: Rocket {
        return Rocket(flickrImages: [], name: "", type: "", id: "")
    }
}
