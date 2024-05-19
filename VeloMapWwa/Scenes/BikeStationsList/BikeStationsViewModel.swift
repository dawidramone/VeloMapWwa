//
//  BikeStationsViewModel.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Foundation

@MainActor
class BikeStationsViewModel: ObservableObject {
    @Published var hasAppeared = false
    @Published var bikeStations: [Place] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchBikeStations() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: BikeStationResponse = try await NetworkingManager.shared.fetchData(from: .warsawBikeStations, responseType: BikeStationResponse.self)

            let warsawStations = response.countries
                .flatMap { $0.cities }
                .filter { $0.name.lowercased() == "warszawa" || $0.name.lowercased() == "warsaw" }
                .flatMap { $0.places }

            DispatchQueue.main.async {
                self.bikeStations = warsawStations
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
