//
//  STWMessagingApp
//
//  Created by khawla 
//


import UIKit
import CoreLocation
import MapKit

// Controller displaying a list of Points of Interest (POIs) near the user
class POIListViewController: UITableViewController, CLLocationManagerDelegate {

var locationManager = CLLocationManager()
var pois: [POIItem] = []

override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Points of Interest", comment: "")
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
     // Load static POI data
    loadPOIs()
}
 // Load predefined POIs with their coordinates
func loadPOIs() {
    pois = [
        POIItem(name: "Coffee Shop", latitude: 36.81, longitude: 10.18),
        POIItem(name: "Mall", latitude: 36.83, longitude: 10.15),
        POIItem(name: "Park", latitude: 36.84, longitude: 10.20)
    ]
    tableView.reloadData()
}
// Called whenever the user's location changes

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let current = locations.last else { return }
            // Update each POI's distance from the user's current position

    for i in 0..<pois.count {
        pois[i].updateDistance(from: current)
    }
            // Refresh the table to display updated distances

    tableView.reloadData()
}

// MARK: - Table View Data Source

// Number of POIs to display in the list
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pois.count
}

    // Configure each table cell with POI name and distance

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "poiCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "poiCell")
    let poi = pois[indexPath.row]
    // Display POI name
    cell.textLabel?.text = poi.name
    // Display POI distance if available
    if let dist = poi.distance {
        cell.detailTextLabel?.text = "\(Int(dist)) m"
    }
    return cell
}

 // When a POI is selected, open its location in Apple Maps
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let poi = pois[indexPath.row]
    let coord = CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
            // Create a MapKit item and open in Maps app

    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord))
    mapItem.name = poi.name
    mapItem.openInMaps()
}
}
