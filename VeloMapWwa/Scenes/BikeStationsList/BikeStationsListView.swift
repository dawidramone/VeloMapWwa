//
//  BikeStationsListView.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import SwiftUI

@MainActor
class BikeStationsViewModel: ObservableObject {
    @Published var bikeStations: [Place] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchBikeStations() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: BikeStationResponse = try await NetworkingManager.shared.fetchData(from: .warsawBikeStations, responseType: BikeStationResponse.self)

            var warsawStations: [Place] = []

            for country in response.countries {
                for city in country.cities {
                    if city.name.lowercased() == "warszawa" || city.name.lowercased() == "warsaw" {
                        warsawStations.append(contentsOf: city.places)
                    }
                }
            }

            bikeStations = warsawStations
        } catch {
            errorMessage = "Failed to fetch data: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

struct BikeStationsListView: View {
    @StateObject private var viewModel = BikeStationsViewModel()
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.isLoading {
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
                    }
                }
            }
            .padding(.top, 1)
        }
        .navigationBarHidden(false)
        .task {
            await viewModel.fetchBikeStations()
        }
    }
}

#Preview {
    BikeStationsListView()
}
