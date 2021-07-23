//
//  Endpoint.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import Foundation

final class Endpoint {
    
    public var route: String
    public var queryItems: [URLQueryItem]
    
    public var url : URL {
        var components = URLComponents(string: self.route)!
        components.queryItems = self.queryItems.isEmpty ? nil : self.queryItems
        
        return components.url!
    }
    
    public func add(queryItem: URLQueryItem) -> Self {
        self.queryItems.append(queryItem)
        return self
    }
    
    public init(route: String) {
        self.route = route
        self.queryItems = .init()
    }
    
}

extension Endpoint {
    
    private static let base: String = "https://api.openweathermap.org/data/2.5/"
    private static let appid: String = ""
    
    public static func getImage(for id: String) -> Endpoint {
        return .init(route: "https://openweathermap.org/img/wn/\(id)@4x.png")
    }
    
    public static func getCurrentWeather(for lat: Double, lon: Double) -> Endpoint {
        return .init(route: self.base + "onecall")
            .add(queryItem: .init(name: "lat", value: "\(lat)"))
            .add(queryItem: .init(name: "lon", value: "\(lon)"))
            .add(queryItem: .init(name: "exclude", value: "minutely,hourly,daily,alerts"))
            .add(queryItem: .init(name: "units", value: "metric"))
            .add(queryItem: .init(name: "appid", value: self.appid))
    }
    
    public static func getDailyWeather(for lat: Double, lon: Double) -> Endpoint {
        return .init(route: self.base + "onecall")
            .add(queryItem: .init(name: "lat", value: "\(lat)"))
            .add(queryItem: .init(name: "lon", value: "\(lon)"))
            .add(queryItem: .init(name: "exclude", value: "current,minutely,hourly,alerts"))
            .add(queryItem: .init(name: "appid", value: self.appid))
    }
    
}
