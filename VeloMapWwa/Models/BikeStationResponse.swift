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

    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case name
        case bike = "bikes"
        case freeRacks = "free_racks"
        case lat
        case lng
    }
}
