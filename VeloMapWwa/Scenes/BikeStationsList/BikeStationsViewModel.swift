//
//  BikeStationsViewModel.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Combine
import CoreLocation

@MainActor
class BikeStationsViewModel: ObservableObject {
    @Published var hasAppeared = false
    @Published var bikeStations: [Place] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var userLocation: CLLocation?

    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.userLocation = location
                Task {
                    await self?.calculateDistances()
                }
            }
            .store(in: &cancellables)
    }

    func fetchBikeStations() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: BikeStationResponse = try await NetworkingManager.shared.fetchData(from: .warsawBikeStations, responseType: BikeStationResponse.self)

            var warsawStations = response.countries
                .flatMap { $0.cities }
                .filter { $0.name.lowercased() == "warszawa" || $0.name.lowercased() == "warsaw" }
                .flatMap { $0.places }

            if let userLocation = userLocation {
                warsawStations = warsawStations.map { updateDistance(for: $0, from: userLocation) }
                warsawStations.sort { ($0.distance ?? Double.greatestFiniteMagnitude) < ($1.distance ?? Double.greatestFiniteMagnitude) }
            }

            bikeStations = warsawStations
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            isLoading = false
        }
    }

    private func calculateDistances() async {
        defer { isLoading = false }
        guard let userLocation = userLocation else { return }

        bikeStations = bikeStations.map { updateDistance(for: $0, from: userLocation) }
    }

    private func updateDistance(for station: Place, from userLocation: CLLocation) -> Place {
        var updatedStation = station
        let stationLocation = CLLocation(latitude: station.lat, longitude: station.lng)
        updatedStation.distance = userLocation.distance(from: stationLocation)
        updatedStation.updateDistanceString()
        return updatedStation
    }
}
