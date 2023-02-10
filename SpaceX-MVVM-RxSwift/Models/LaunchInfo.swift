//
//  LaunchInfo.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import Foundation

struct LaunchInfo: Decodable, Hashable {
    var id: UUID = UUID()
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
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

extension LaunchInfo: Identifiable {}
