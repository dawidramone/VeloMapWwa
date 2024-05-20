//
//  BikeStationResponse.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Foundation

struct BikeStationResponse: Codable {
    let countries: [Country]
}

struct Country: Codable {
    let cities: [City]
}

struct City: Codable {
    let name: String
    let places: [Place]
}

struct Place: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let bike: Int
    let freeRacks: Int
    let lat: Double
    let lng: Double
    var distance: Double? {
        didSet {
            updateDistanceString()
        }
    }

    var address: String?
    var distanceString: String = "Distance not available"

    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case name
        case bike = "bikes"
        case freeRacks = "free_racks"
        case lat
        case lng
        case address
    }

    var fullAddress: String {
        return address ?? "Address not available"
    }

    mutating func updateDistanceString() {
        guard let distance = distance else {
            distanceString = "Distance not available"
            return
        }
        if distance > 1000 {
            distanceString = String(format: "%.1f km", distance / 1000)
        } else {
            distanceString = String(format: "%.0f m", distance)
        }
    }
}
