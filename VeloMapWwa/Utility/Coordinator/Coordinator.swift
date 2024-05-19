//
//  Coordinator.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import SwiftUI

enum Page: Hashable {
    case bikeStationsList
    case bikeStationDetail(Place)
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()

    func push(page: Page) {
        path.append(page)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @MainActor @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .bikeStationsList:
            BikeStationsListView()
        case let .bikeStationDetail(station):
            EmptyView()
        }
    }
}
