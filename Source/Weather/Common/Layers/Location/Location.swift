//
//  Location.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import CoreLocation

typealias LocationResult = Result<(location: CLLocation, city: String), LocationError>
typealias LocationCallback = (LocationResult) -> ()

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
    
    private func process(location: CLLocation, completion: LocationCallback?) -> () {
        self.city(for: location) { city in
            guard let city = city else {
                completion?(.failure(.geocode))
                return
            }
            
            completion?(.success((location, city)))
        }
    }
    
    public func set(lat: Double, lon: Double) -> () {
        self.choosenLocation = .init(latitude: lat, longitude: lon)
    }
    
    public func clear() -> () {
        self.choosenLocation = nil
    }
    
    public func location(completion: LocationCallback?) -> () {
        if let location = self.choosenLocation {
            return self.process(location: location, completion: completion)
        }
        
        self.locationCallback = completion
        
        guard self.isAuthorized else {
            return self.authorize()
        }
        
        self.manager.startUpdatingLocation()
    }
    
    override public init() {
        self.manager = .init()
        
        super.init()
        
        self.manager.delegate = self
    }
    
    deinit {
        self.manager.stopUpdatingLocation()
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
        
        self.process(location: location, completion: self.locationCallback)
        self.locationCallback = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) -> () {
        self.flush(reason: .notDetermined)
    }
}
