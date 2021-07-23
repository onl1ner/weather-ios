//
//  Location.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import CoreLocation

protocol LocationProtocol {
    func location(completion: ((CLLocation?, String?) -> ())?) -> ()
}

final class Location: NSObject, LocationProtocol {
    
    public static let shared: LocationProtocol = Location()
    
    private var manager: CLLocationManager
    
    private var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
            || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    private var locationCallback: ((CLLocation?, String?) -> ())?
    
    private func flush() -> () {
        self.locationCallback?(nil, nil)
        self.locationCallback = nil
    }
    
    private func authorize() -> () {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
        }
        
        self.flush()
    }
    
    public func location(completion: ((CLLocation?, String?) -> ())?) {
        self.locationCallback = completion
        
        guard self.isAuthorized else {
            return self.authorize()
        }
        
        self.manager.requestLocation()
    }
    
    override public init() {
        self.manager = .init()
        
        super.init()
        
        self.manager.delegate = self
    }
    
}

extension Location: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) -> () {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return self.location(completion: self.locationCallback)
        }
        
        self.flush()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> () {
        guard let location = locations.last else { return self.flush() }
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil,
                  let placemark = placemarks?.first,
                  let city = placemark.locality
            else { return self.flush() }
            
            self.locationCallback?(location, city)
            self.locationCallback = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) -> () {
        self.flush()
    }
}
