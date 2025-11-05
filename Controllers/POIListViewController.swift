import UIKit
import CoreLocation
import MapKit

class POIListViewController: UITableViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var pois: [POIItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Points of Interest", comment: "")
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        loadPOIs()
    }

    func loadPOIs() {
        pois = [
            POIItem(name: "Coffee Shop", latitude: 36.81, longitude: 10.18),
            POIItem(name: "Mall", latitude: 36.83, longitude: 10.15),
            POIItem(name: "Park", latitude: 36.84, longitude: 10.20)
        ]
        tableView.reloadData()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let current = locations.last else { return }
        for i in 0..<pois.count {
            pois[i].updateDistance(from: current)
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pois.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poiCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "poiCell")
        let poi = pois[indexPath.row]
        cell.textLabel?.text = poi.name
        if let dist = poi.distance {
            cell.detailTextLabel?.text = "\(Int(dist)) m"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poi = pois[indexPath.row]
        let coord = CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord))
        mapItem.name = poi.name
        mapItem.openInMaps()
    }
}
