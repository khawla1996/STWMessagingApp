import Foundation
import CoreLocation
import UIKit

/// A simple helper class to get the user's current location once (one-shot)
public final class LocationManager: NSObject {
    
    // Shared instance (singleton) used throughout the app
    public static let shared = LocationManager()
    
    // CLLocationManager instance from CoreLocation
    private let manager = CLLocationManager()
    
    // Completion handler to return the location result
    private var completion: ((CLLocation?) -> Void)?

    // Private initializer so only one instance can exist
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest  // Use best accuracy available
    }

    /// Request the user's current location (called once)
    /// The completion block returns the location or nil if failed
    public func requestLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion

        // Check the authorization status
        let status = CLLocationManager.authorizationStatus()
        
        // If permission not asked yet, request it
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }

        // If user denied or restricted access, return nil
        if status == .denied || status == .restricted {
            completion(nil)
            return
        }

        // Request one-time location update
        manager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    // Called when location is successfully retrieved
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last   // Get the most recent location
        completion?(loc)           // Return location via completion
        completion = nil           // Clear completion to avoid multiple calls
    }

    // Called if location update fails
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error:", error.localizedDescription)
        completion?(nil)   // Return nil to indicate failure
        completion = nil
    }

}
