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

    private let stroke = StrokeStyle(lineWidth: 2, lineCap: .square, lineJoin: .miter, dash: [5, 5])

    init(station: Place) {
        _viewModel = ObservedObject(wrappedValue: BikeStationDetailViewModel(station: station))
    }

    var body: some View {
        PageLayout(showBackButton: true) {
            coordinator.pop()
        } content: {
            VStack {
                ZStack {
                    Map(position: $viewModel.position) {
                        UserAnnotation()
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: viewModel.station.lat, longitude: viewModel.station.lng)) {
                            Button {
                                Task {
                                    showStationDetails.toggle()
                                    await viewModel.getDirections()
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

                        if let route = viewModel.route, showStationDetails {
                            MapPolyline(route.polyline)
                                .stroke(.blue, style: stroke)
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
}

#Preview {
    BikeStationDetailView(station: Place(id: 1,
                                         name: "047 Ofiar Dąbia",
                                         bike: 7,
                                         freeRacks: 20,
                                         lat: 50.0671,
                                         lng: 19.9442))
}
