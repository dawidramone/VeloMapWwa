//
//  Endpoint.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Foundation

enum CityCode: Int {
    case warsaw = 812
}

enum API {
    enum Base {
        static let scheme = "https"
        static let host = "api.nextbike.net"
        static let path = "/maps/nextbike-live.json"
    }

    enum Endpoints {
        static func nextbikeLive(city: CityCode) -> Endpoint {
            Endpoint(
                scheme: Base.scheme,
                host: Base.host,
                path: Base.path,
                queryItems: [URLQueryItem(name: "city", value: "\(city.rawValue)")]
            )
        }
    }
}

struct Endpoint {
    let scheme: String
    let host: String
    let path: String
    let queryItems: [URLQueryItem]?

    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
