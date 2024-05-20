//
//  BikeStationDetailViewModel.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Combine
import MapKit
import SwiftUI

class BikeStationDetailViewModel: ObservableObject {
    @Published var station: Place
    @Published var region: MKCoordinateRegion
    @Published var userLocation: CLLocation?

    var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

    init(station: Place) {
        self.station = station
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        bindingForLocation()
    }
    
    private func bindingForLocation() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.userLocation = location
            }
            .store(in: &cancellables)
    }
        
}
