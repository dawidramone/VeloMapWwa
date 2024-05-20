//
//  BikeStationDetailView.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import MapKit
import SwiftUI

struct BikeStationDetailView: View {
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject var viewModel: BikeStationDetailViewModel

    @State private var showStationDetails = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var position: MapCameraPosition = .automatic
    @State private var transportType = MKDirectionsTransportType.walking
    @State private var travelInterval: TimeInterval?

    init(station: Place) {
        _viewModel = ObservedObject(wrappedValue: BikeStationDetailViewModel(station: station))
    }

    var body: some View {
        PageLayout(showBackButton: true) {
            coordinator.pop()
        } content: {
            VStack {
                ZStack {
                    Map(position: $position) {
                        UserAnnotation()
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: viewModel.station.lat, longitude: viewModel.station.lng)) {
                            Button {
                                Task {
                                    showStationDetails.toggle()
                                    await getDirections()
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text("\(viewModel.station.bike)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                    Image(.bike)
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                            }
                        }

                        if let route, showStationDetails {
                            MapPolyline(route.polyline)
                                .stroke(.blue, lineWidth: 6)
                        }
                    }
                    .mapStyle(.standard)
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                        MapScaleView()
                    }

                    VStack {
                        Spacer()
                        BikeStationRowView(isOnMap: true, station: viewModel.station)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .opacity(showStationDetails ? 1 : 0)
                    .offset(y: showStationDetails ? 0 : UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.5), value: showStationDetails)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }

    func getDirections() async {
        guard let userLocation = viewModel.locationManager.location else { return }
        let request = MKDirections.Request()
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let routeSource = MKMapItem(placemark: sourcePlacemark)
        let destinatinPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.station.lat, longitude: viewModel.station.lng))
        routeDestination = MKMapItem(placemark: destinatinPlacemark)
        routeDestination?.name = viewModel.station.name
        request.source = routeSource
        request.destination = routeDestination
        request.transportType = transportType
        let directions = MKDirections(request: request)
        let result = try? await directions.calculate()
        route = result?.routes.first
        travelInterval = route?.expectedTravelTime
    }
}

#Preview {
    BikeStationDetailView(station: Place(id: 1,
                                         name: "047 Ofiar Dąbia",
                                         bike: 7,
                                         freeRacks: 20,
                                         lat: 50.0671,
                                         lng: 19.9442))
}
