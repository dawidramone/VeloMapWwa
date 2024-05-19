//
//  CoordinatorView.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()

    var body: some View {
        stationsListRootView()
            .environmentObject(coordinator)
    }

    private func stationsListRootView() -> some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .bikeStationsList)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                        .navigationBarBackButtonHidden(true)
                }
        }
        .environmentObject(coordinator)
    }
}
