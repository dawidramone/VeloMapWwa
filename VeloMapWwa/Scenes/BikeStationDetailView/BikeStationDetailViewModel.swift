//
//  BikeStationDetailViewModel.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import _MapKit_SwiftUI
import Foundation
import MapKit

class BikeStationDetailViewModel: ObservableObject {
    var station: Place
    var region: MKCoordinateRegion
    var cameraPosition: MapCameraPosition

    init(station: Place) {
        self.station = station
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        cameraPosition = MapCameraPosition.region(region)
    }
}
