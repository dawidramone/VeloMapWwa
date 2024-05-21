//
//  BikeStationsViewModel.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Combine
import CoreLocation
import SwiftUI

class BikeStationsViewModel: ObservableObject, LocationSubscriber {
    @Published var hasAppeared = false
    @Published var bikeStations: [Place] = []
    @Published var isLoading: Bool = false
    @Published var userLocation: CLLocation? {
        didSet {
            Task {
                await calculateDistances()
            }
        }
    }

    @Published var hasError: Bool = false

    var locationManager: LocationManager
    var cancellables = Set<AnyCancellable>()

    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        subscribeToLocationUpdates()
    }

    @MainActor
    func fetchBikeStations(isLoading: Bool = true) async {
        defer { self.isLoading = false }

        do {
            self.isLoading = isLoading
            let response: BikeStations = try await NetworkingManager.shared.fetchData(from: API.Endpoints.nextbikeLive(city: .warsaw), responseType: BikeStations.self)

            let countries = response.countries
            let cities = countries.flatMap { $0.cities }
            let warsawCities = cities.filter { $0.name.lowercased() == "warszawa" || $0.name.lowercased() == "warsaw" }
            var warsawStations = warsawCities.flatMap { $0.places }

            if let userLocation = userLocation {
                warsawStations = warsawStations.map { updateDistance(for: $0, from: userLocation) }
                warsawStations.sort { ($0.distance ?? .greatestFiniteMagnitude) < ($1.distance ?? .greatestFiniteMagnitude) }
            }
            bikeStations = warsawStations
        } catch {
            hasError = true
        }
    }

    @MainActor
    func calculateDistances() async {
        guard let userLocation = userLocation else { return }

        bikeStations = bikeStations.map { updateDistance(for: $0, from: userLocation) }
    }

    func updateDistance(for station: Place, from userLocation: CLLocation) -> Place {
        var updatedStation = station
        let stationLocation = CLLocation(latitude: station.lat, longitude: station.lng)
        updatedStation.distance = userLocation.distance(from: stationLocation)
        updatedStation.updateDistanceString()
        return updatedStation
    }
}
