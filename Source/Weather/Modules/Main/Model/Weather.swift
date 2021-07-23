//
//  Weather.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import UIKit

struct WeatherInfo: Codable {
    public let main: String
    private let icon: String
    
    public func icon(completion: @escaping (UIImage?) -> ()) -> () {
        Network.shared.image(with: self.icon) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

struct Weather: Codable {
    
    private let temp: Double
    private let windSpeed: Double
    private let hum: Double
    
    private let weatherInfo: [WeatherInfo]
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case windSpeed = "wind_speed"
        case hum = "humidity"
        case weatherInfo = "weather"
    }
    
    public var weather: String {
        if let weather = self.weatherInfo.first {
            return weather.main
        }
        
        return "ERROR"
    }
    
    public var temperature: String {
        return "\(Int(round(self.temp)))º"
    }
    
    public var wind: String {
        return "\(Int(round(self.windSpeed))) m/s"
    }
    
    public var humidity: String {
        return "\(Int(round(self.hum)))%"
    }
    
    public func icon(completion: @escaping (UIImage?) -> ()) -> () {
        if let weather = self.weatherInfo.first {
            return weather.icon(completion: completion)
        }
        
        completion(nil)
    }
}
