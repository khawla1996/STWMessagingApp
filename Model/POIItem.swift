import Foundation
import CoreLocation

/// Simple Codable model to serialize a POI list inside Message.poiData
public struct POIItem: Codable {
    public let name: String
    public let latitude: Double
    public let longitude: Double

    // distance is calculated at runtime (not persisted)
    public var distance: CLLocationDistance?

    public init(name: String, latitude: Double, longitude: Double, distance: CLLocationDistance? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
    }

    /// Update distance from a reference location
    public mutating func updateDistance(from location: CLLocation) {
        let poiLocation = CLLocation(latitude: latitude, longitude: longitude)
        distance = location.distance(from: poiLocation)
    }
}
