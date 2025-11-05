import Foundation
import CoreLocation
import UIKit

/// Small wrapper around CLLocationManager to request one-shot location easily.
public final class LocationManager: NSObject {
    public static let shared = LocationManager()
    private let manager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// Request current location (one-shot). The completion is called with the last known location or nil.
    public func requestLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion

        // Authorization
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }

        // If user denied, return nil
        if status == .denied || status == .restricted {
            completion(nil)
            return
        }

        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        completion?(loc)
        completion = nil
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error:", error.localizedDescription)
        completion?(nil)
        completion = nil
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // nothing special here; next requestLocation() will attempt to get location
    }
}
