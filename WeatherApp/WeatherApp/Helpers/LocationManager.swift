//
//  LocationManager.swift

//

import Foundation
import CoreLocation

@objc protocol LocationManagerDelegate {
    @objc optional func locationDidAuthorized();
    @objc optional func locationDidDenied();
}
struct LocationDetails {
    var location: CLLocation?
    var address: String?
    var city: String?
    init(location: CLLocation) {
        self.location = location
    }
}
class LocationManager: NSObject,  CLLocationManagerDelegate {
    public static var sharedInstance = LocationManager()
    
    var locationManager: CLLocationManager!
    
    var delegate:LocationManagerDelegate!
    
    
    var locationDetail: CLLocation??
    
    func startLocationService() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:  [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        self.locationDetail = locationObj
        delegate?.locationDidAuthorized!()        
    }
    func authStatusLocation() -> CLAuthorizationStatus {
        guard let locationManager = self.locationManager else {
            return .notDetermined
        }
        return locationManager.authorizationStatus
    }
    func isEnableLocation() -> Bool {
        if authStatusLocation() == .authorizedAlways || authStatusLocation() == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    // authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted:
            delegate?.locationDidDenied!()
            break
        case CLAuthorizationStatus.denied:
            delegate?.locationDidDenied!()
            break
        case CLAuthorizationStatus.notDetermined:
            delegate?.locationDidDenied!()
            break
        default:
            delegate?.locationDidAuthorized!()
            break
        }
    }
}


