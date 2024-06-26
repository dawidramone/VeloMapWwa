//
//  NetworkingManager.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Foundation

final class NetworkingManager {
    static let shared = NetworkingManager()

    private init() {}

    fileprivate enum NetworkError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
    }

    func fetchData<T: Decodable>(from endpoint: Endpoint, responseType: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            let decodedData = try JSONDecoder().decode(responseType, from: data)
            return decodedData
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
