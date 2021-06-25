//
//  LocationSettingVC.swift
//  Marauders
//
//  Created by somsak on 17/2/2564 BE.
//

import UIKit
import CoreLocation

class LocationSettingVC: BaseVC {
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startLoading()
        configureCLLocationManager()
    }
    
    @IBAction func openSettingAction(_ sender: Any) {
        //Redirect to Settings app
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
//
//    @objc func onLocationPermission(){
//        print("onLocationPermission")
//        configureCLLocationManager()
//    }
    
    func configureCLLocationManager(){
        // Step 2: initalise and configure CLLocationManager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        // Step 3: request authorization
//        locationManager?.requestAlwaysAuthorization()
    }
}

// Step 5: Implement the CLLocationManagerDelegate to handle the callback from CLLocationManager
extension LocationSettingVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied: // Setting option: Never
          print("LocationManager didChangeAuthorization denied")
            self.stopLoading()
//            self.alert(title: "Location setting.") { (bool) in
//                let locationServices = UserDefaults.standard.bool(forKey: "locationServices")
//                if locationServices {
//                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//                    print("true true")
//                }else{
//                    UIApplication.shared.open(URL(string: "App-prefs:root=LOCATION_SERVICES")!)
//                    print("false false")
//                }
//            }
            
            self.performSegue(withIdentifier: "goToLocationSetting", sender: nil)
            
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
//        self.latLongData[0] = location.coordinate.latitude
//        self.latLongData[1] = location.coordinate.longitude
//        goToHomeScreen()
        
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
