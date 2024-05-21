//
//  LocationManager.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Combine
import CoreLocation
import UIKit

protocol LocationSubscriber: AnyObject {
    var locationManager: LocationManager { get set }
    var cancellables: Set<AnyCancellable> { get set }
    var userLocation: CLLocation? { get set }

    func subscribeToLocationUpdates()
}

extension LocationSubscriber {
    func subscribeToLocationUpdates() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.userLocation = location
            }
            .store(in: &cancellables)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func appDidEnterBackground() {
        locationManager.stopUpdatingLocation()
    }

    @objc private func appWillEnterForeground() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
