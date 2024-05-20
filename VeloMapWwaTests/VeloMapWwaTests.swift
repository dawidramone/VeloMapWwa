//
//  VeloMapWwaTests.swift
//  VeloMapWwaTests
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Combine
import CoreLocation
@testable import VeloMapWwa
import XCTest

final class VeloMapWwaTests: XCTestCase {
    var viewModel: BikeStationsViewModel!
    var cancellables: Set<AnyCancellable>!

    @MainActor override func setUp() {
        super.setUp()
        viewModel = BikeStationsViewModel(locationManager: MockLocationManager())
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    @MainActor
    func testCalculateDistancesWithUserLocation() async {
        let expectation = XCTestExpectation(description: "Distance calculation completed")

        let station1 = Place(id: 1, name: "Station 1", bike: 1, freeRacks: 1, lat: 52.2296756, lng: 21.0122287)
        let station2 = Place(id: 2, name: "Station 2", bike: 2, freeRacks: 3, lat: 52.406374, lng: 16.9251681)

        viewModel.bikeStations = [station1, station2]
        viewModel.userLocation = CLLocation(latitude: 52.2296756, longitude: 21.0122287)

        await viewModel.calculateDistances()

        XCTAssertNotNil(viewModel.bikeStations[0].distance)
        XCTAssertNotNil(viewModel.bikeStations[1].distance)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    @MainActor
    func testUpdateDistance() {
        let station = Place(id: 1, name: "Station 1", bike: 1, freeRacks: 1, lat: 52.2296756, lng: 21.0122287)
        let userLocation = CLLocation(latitude: 52.2296756, longitude: 21.0122287)

        let updatedStation = viewModel.updateDistance(for: station, from: userLocation)

        XCTAssertEqual(updatedStation.distance, 0)
    }

    @MainActor
    func testUpdateDistanceNotEqual() {
        let station = Place(id: 1, name: "Station 1", bike: 1, freeRacks: 1, lat: 52.2296756, lng: 21.0122287)
        let userLocation = CLLocation(latitude: 51.2296756, longitude: 21.0122287)

        let updatedStation = viewModel.updateDistance(for: station, from: userLocation)

        XCTAssertNotEqual(updatedStation.distance, 0)
    }
}

class MockLocationManager: LocationManager {
    override init() {
        super.init()
        location = CLLocation(latitude: 52.2296756, longitude: 21.0122287)
    }
}
