//
//  Location.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import CoreLocation

typealias LocationCallback = (Result<(location: CLLocation, city: String), LocationError>) -> ()

protocol LocationProtocol {
    func set(lat: Double, lon: Double) -> ()
    func clear() -> ()
    
    func location(completion: LocationCallback?) -> ()
}

final class Location: NSObject, LocationProtocol {
    
    public static let shared: LocationProtocol = Location()
    
    private var manager: CLLocationManager
    private var choosenLocation: CLLocation?
    
    private var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
            || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    private var locationCallback: LocationCallback?
    
    private func flush(reason: LocationError) -> () {
        self.locationCallback?(.failure(reason))
        self.locationCallback = nil
    }
    
    private func authorize() -> () {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            return self.manager.requestWhenInUseAuthorization()
        }
        
        self.flush(reason: .unauthorized)
    }
    
    private func city(for location: CLLocation, completion: @escaping (String?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil,
                  let placemark = placemarks?.first,
                  let city = placemark.locality
            else { return completion(nil) }
            
            completion(city)
        }
    }
    
    public func set(lat: Double, lon: Double) -> () {
        self.choosenLocation = .init(latitude: lat, longitude: lon)
    }
    
    public func clear() -> () {
        self.choosenLocation = nil
    }
    
    public func location(completion: LocationCallback?) -> () {
        if let choosenLocation = self.choosenLocation {
            self.city(for: choosenLocation) { city in
                if let city = city {
                    completion?(.success((choosenLocation, city)))
                } else {
                    completion?(.failure(.geocode))
                }
            }
            
            return
        }
        
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
        
        self.flush(reason: .unauthorized)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> () {
        guard let location = locations.last else { return self.flush(reason: .internal) }
        
        self.city(for: location) { city in
            guard let city = city else { return self.flush(reason: .internal) }
            
            self.locationCallback?(.success((location, city)))
            self.locationCallback = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) -> () {
        self.flush(reason: .notDetermined)
    }
}
