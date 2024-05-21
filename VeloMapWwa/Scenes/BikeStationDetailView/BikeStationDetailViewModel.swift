//
//  BikeStationDetailViewModel.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Combine
import MapKit
import SwiftUI

class BikeStationDetailViewModel: ObservableObject, LocationSubscriber {
    @Published var station: Place
    @Published var userLocation: CLLocation?
    @Published var route: MKRoute?
    @Published var routeDestination: MKMapItem?
    @Published var position: MapCameraPosition = .automatic
    @Published var transportType = MKDirectionsTransportType.walking

    var locationManager: LocationManager
    var cancellables = Set<AnyCancellable>()

    init(station: Place, locationManager: LocationManager = LocationManager()) {
        self.station = station
        self.locationManager = locationManager
        subscribeToLocationUpdates()
    }

    @MainActor
    func getDirections() async {
        guard let userLocation = locationManager.location else { return }
        let request = MKDirections.Request()
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let routeSource = MKMapItem(placemark: sourcePlacemark)
        let destinatinPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:
            station.lat,
            longitude:
            station.lng))
        routeDestination = MKMapItem(placemark: destinatinPlacemark)
        request.source = routeSource
        request.destination = routeDestination
        request.transportType = transportType
        let directions = MKDirections(request: request)
        let result = try? await directions.calculate()
        route = result?.routes.first
    }
}
