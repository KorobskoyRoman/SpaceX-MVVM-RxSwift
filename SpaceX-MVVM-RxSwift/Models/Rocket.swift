//
//  Rocket.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 03.02.2023.
//

import Foundation

struct Rocket: Decodable {
    let height, diameter: Size
    let country: String
    let costPerLaunch: Int
    let mass: Mass
    let firstStage: FirstStage
    let secondStage: SecondStage
    let engines: Engines
    let landingLegs: LandingLegs
    let payloadWeights: [PayloadWeight]
    let flickrImages: [String]?
    let name, type: String?
    let id: String?
    let wikipedia: String

    enum CodingKeys: String, CodingKey {
        case flickrImages = "flickr_images"
        case payloadWeights = "payload_weights"
        case costPerLaunch = "cost_per_launch"
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case landingLegs = "landing_legs"
        case name, type, id, height, diameter, mass, country, engines, wikipedia
    }
}

struct Size: Decodable {
    let meters, feet: Double?
}

struct Mass: Decodable {
    let kg, lb: Double
}

struct FirstStage: Decodable {
    let thrustSeaLevel, thrustVacuum: Thrust
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
        case reusable, engines
    }
}

struct SecondStage: Decodable {
    let thrust: Thrust
    let payloads: Payloads
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
        case thrust, payloads, reusable, engines
    }
}

struct Engines: Decodable {
    let isp: ISP
    let thrustSeaLevel, thrustVacuum: Thrust
    let number: Int
    let type, version: String
    let layout: String?
    let engineLossMax: Int?
    let propellant1, propellant2: String
    let thrustToWeight: Double

    enum CodingKeys: String, CodingKey {
        case isp, number, type, version, layout
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case engineLossMax = "engine_loss_max"
        case thrustToWeight = "thrust_to_weight"
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
    }
}

struct LandingLegs: Decodable {
    let number: Int
    let material: String?
}

struct ISP: Decodable {
    let seaLevel, vacuum: Int

    enum CodingKeys: String, CodingKey {
        case seaLevel = "sea_level"
        case vacuum
    }
}

struct Thrust: Decodable {
    let kN, lbf: Int
}

struct Payloads: Decodable {
    let compositeFairing: CompositeFairing
    let option1: String

    enum CodingKeys: String, CodingKey {
        case option1 = "option_1"
        case compositeFairing = "composite_fairing"
    }
}

struct PayloadWeight: Decodable {
    let id, name: String
    let kg, lb: Double
}

struct CompositeFairing: Decodable {
    let height, diameter: Size
}

extension Rocket {
    static var emptyRocket: Rocket {
        Rocket(
            height: Size(meters: 0, feet: 0),
            diameter: Size(meters: 0, feet: 0),
            country: "",
            costPerLaunch: 0,
            mass: Mass(kg: 0, lb: 0),
            firstStage: FirstStage(thrustSeaLevel: Thrust(kN: 0, lbf: 0), thrustVacuum: Thrust(kN: 0, lbf: 0), reusable: true, engines: 0, fuelAmountTons: 0.0, burnTimeSEC: 0),
            secondStage: SecondStage(thrust: Thrust(kN: 0, lbf: 0), payloads: Payloads(compositeFairing: CompositeFairing(height: Size(meters: 0, feet: 0), diameter: Size(meters: 0, feet: 0)), option1: "0"), reusable: true, engines: 0, fuelAmountTons: 0, burnTimeSEC: 0),
            engines: Engines(isp: ISP(seaLevel: 0, vacuum: 0), thrustSeaLevel: Thrust(kN: 0, lbf: 0), thrustVacuum: Thrust(kN: 0, lbf: 0), number: 0, type: "0", version: "s", layout: "0", engineLossMax: 0, propellant1: "0", propellant2: "0", thrustToWeight: 0),
            landingLegs: LandingLegs(number: 0, material: "0"),
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
            id: "",
            wikipedia: ""
        )
    }
}
