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
    @State private var showStationDetails = false
    @ObservedObject var viewModel: BikeStationDetailViewModel

    init(station: Place) {
        viewModel = BikeStationDetailViewModel(station: station)
    }

    var body: some View {
        PageLayout(showBackButton: true) {
            coordinator.pop()
        } content: {
            VStack {
                ZStack {
                    // TODO: deprecated in iOS 17.0, replace with new Map
                    Map(coordinateRegion: $viewModel.region, annotationItems: [viewModel.station]) { station in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng)) {
                            Button {
                                withAnimation {
                                    showStationDetails.toggle()
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text("\(station.bike)")
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
                    }
                    .edgesIgnoringSafeArea(.all)

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
