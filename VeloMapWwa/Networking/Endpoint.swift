//
//  Endpoint.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Foundation

struct Endpoint {
    let path: String

    static let warsawBikeStations = Endpoint(path: "https://api.nextbike.net/maps/nextbike-live.json?city=812")
}
