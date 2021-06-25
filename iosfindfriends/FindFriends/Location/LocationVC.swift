//
//  LocationVC.swift
//  FindFriends
//
//  Created by somsak on 17/1/2564 BE.
//

import UIKit
import CoreLocation
import MapKit

class LocationVC: BaseViewController, LocationModelDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet weak var acceptBTN: ButtonIBDesignable!
    
    // Step 2: Declare a CLLocationManager object at the ViewController level to prevent the instance from being released by system.
    var locationManager: CLLocationManager?
    private var viewModel: LocationModel!
    
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = LocationModel(view: self)
        
        self.acceptBTN.isHidden = true
        configureCLLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onLocationPermission), name: Notification.Name("OnLocationPermission"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("OnLocationPermission"), object: nil)
    }
    
    @objc func onLocationPermission(){
        print("onLocationPermission")
        configureCLLocationManager()
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        self.viewModel.sendLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    func configureCLLocationManager(){
        self.startAnimating()
        // Step 3: initalise and configure CLLocationManager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        // Step 4: request authorization
        locationManager?.requestAlwaysAuthorization()
    }
    
    func initialLocation(){
        let initialLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        mapView.centerToLocation(initialLocation)
        
        // Show artwork on map
        let artwork = Artwork(
          title: "Your location",
          locationName: "Your location",
          discipline: "Sculpture",
          coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
        mapView.addAnnotation(artwork)
        self.stopAnimating()
        self.acceptBTN.isHidden = false
    }
    
    func didFinishSendLocation(_ status: statusWebService, code: String) {
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
}

// Step 5: Implement the CLLocationManagerDelegate to handle the callback from CLLocationManager
extension LocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied: // Setting option: Never
          print("LocationManager didChangeAuthorization denied")
            self.stopAnimating()
            self.alert(title: "Location setting.") { (bool) in
                let locationServices = UserDefaults.standard.bool(forKey: "locationServices")
                if locationServices {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                    print("true true")
                }else{
                    UIApplication.shared.open(URL(string: "App-prefs:root=LOCATION_SERVICES")!)
                    print("false false")
                }
            }
            
        case .notDetermined: // Setting option: Ask Next Time
          print("LocationManager didChangeAuthorization notDetermined")
            UserDefaults.standard.set(true, forKey: "locationServices")
            self.dismiss(animated: true) {}
            
        case .authorizedWhenInUse: // Setting option: While Using the App
          print("LocationManager didChangeAuthorization authorizedWhenInUse")
          // Stpe 6: Request a one-time location information
          locationManager?.requestLocation()
            
        case .authorizedAlways: // Setting option: Always
          print("LocationManager didChangeAuthorization authorizedAlways")
          // Stpe 6: Request a one-time location information
          locationManager?.requestLocation()
            
        case .restricted: // Restricted by parental control
          print("LocationManager didChangeAuthorization restricted")
            
        default:
          print("LocationManager didChangeAuthorization")
        }
    }

  // Step 7: Handle the location information
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("LocationManager didUpdateLocations: numberOfLocation: \(locations.count)")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    locations.forEach { (location) in
      print("LocationManager didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude), \(location.coordinate.longitude)")
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        initialLocation()
      print("LocationManager altitude: \(location.altitude)")
//      print("LocationManager floor?.level: \(location.floor?.level)")
      print("LocationManager horizontalAccuracy: \(location.horizontalAccuracy)")
      print("LocationManager verticalAccuracy: \(location.verticalAccuracy)")
      print("LocationManager speedAccuracy: \(location.speedAccuracy)")
      print("LocationManager speed: \(location.speed)")
      print("LocationManager timestamp: \(location.timestamp)")
      print("LocationManager courseAccuracy: \(location.courseAccuracy)") // 13.4
      print("LocationManager course: \(location.course)")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("LocationManager didFailWithError \(error.localizedDescription)")
    if let error = error as? CLError, error.code == .denied {
       // Location updates are not authorized.
      // To prevent forever looping of `didFailWithError` callback
       locationManager?.stopMonitoringSignificantLocationChanges()
       return
    }
  }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let discipline: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
