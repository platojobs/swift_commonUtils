import UIKit
import MapKit

enum KALocationError: Error {
    case denied
    case timeout
}

class KALocationManager: NSObject {
    static let shared = KALocationManager()
    private override init() {}
    
    private let locationManager = CLLocationManager()
    
    private var done: ((CLLocation?, Error?) -> Void)?
    
    private var isRealTimeTracking = false
    
    func getCurrentLocation(isRealTimeTracking: Bool, done: @escaping (CLLocation?, Error?) -> Void) {
        self.done = done
        self.isRealTimeTracking = isRealTimeTracking
        enableBasicLocationServices()
    }
    
    func stopTrackingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func enableBasicLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            enableMyWhenInUseFeatures()
            break
        }
    }
    
    func enableMyWhenInUseFeatures() {
        log.debug("when in use")
        
        locationManager.startUpdatingLocation()
    }
    
    func disableMyLocationBasedFeatures() {
        log.debug("disabled")
        
        done?(nil, KALocationError.denied)
    }
}

extension KALocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, location.isValid {
            done?(location, nil)
            if !isRealTimeTracking {
                locationManager.stopUpdatingLocation()
            }
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        done?(nil, error)
    }
}

extension CLLocation {
    var isValid: Bool {
        log.debug(horizontalAccuracy)
        
        let maxAge: TimeInterval = 60
//        let requiredAccuracy: CLLocationAccuracy = 300
//        return Date().timeIntervalSince(timestamp) < maxAge && horizontalAccuracy <= requiredAccuracy
        return Date().timeIntervalSince(timestamp) < maxAge
    }
}
