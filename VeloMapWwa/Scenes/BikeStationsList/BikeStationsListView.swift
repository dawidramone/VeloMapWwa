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
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    List(viewModel.bikeStations) { station in
                        Button(action: {
                            coordinator.push(page: .bikeStationDetail(station))
                        }) {
                            BikeStationRowView(station: station)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .task {
                if !viewModel.hasAppeared {
                    await viewModel.fetchBikeStations()
                    viewModel.hasAppeared = true
                }
            }
            .refreshable {
                await viewModel.fetchBikeStations(isLoading: false)
            }
            .alert(isPresented: $viewModel.hasError) {
                Alert(
                    title: Text("Error"),
                    message: Text("Something went wrong..."),
                    dismissButton: .default(Text("OK"))
                )
            }
        })
    }
}

#Preview {
    BikeStationsListView()
}
