//
//  BikeStationsListView.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import SwiftUI

struct BikeStationsListView: View {
    @StateObject private var viewModel = BikeStationsViewModel()
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        PageLayout(showBackButton: false, content: {
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)
                VStack {
                    if viewModel.isLoading && !viewModel.hasAppeared {
                        ProgressView("Loading...")
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(viewModel.bikeStations) { station in
                                    Button(action: {
                                        coordinator.push(page: .bikeStationDetail(station))
                                    }) {
                                        BikeStationRowView(station: station)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding()
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
            .task {
                if !viewModel.hasAppeared {
                    await viewModel.fetchBikeStations()
                    viewModel.hasAppeared = true
                }
            }
        })
    }
}

#Preview {
    BikeStationsListView()
}
