//
//  Weather.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import UIKit

enum WeatherInfoType: Int, CaseIterable {
    case feelsLike = 0
    case wind
    
    case sunrise
    case sunset
    
    case humidity
    case clouds
    
    case uvi
    
    case visibility
    
    public var title: String {
        switch self {
            case .feelsLike: return "Feels like"
            case .wind: return "Wind speed"
            case .sunrise: return "Sunrise"
            case .sunset: return "Sunset"
            case .humidity: return "Humidity"
            case .clouds: return "Clouds"
            case .uvi: return "UV index"
            case .visibility: return "Visibility"
        }
    }
    
}

struct WeatherInfo: Codable {
    private let icon: String
    
    public let main: String
    
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
    private let feelsLikeRaw: Double
    
    private let windSpeed: Double
    
    private let humidityRaw: Double
    private let cloudsRaw: Double
    
    private let sunriseRaw: TimeInterval
    private let sunsetRaw: TimeInterval
    
    private let uviRaw: Double
    private let visibilityRaw: Int
    
    private let weatherInfo: [WeatherInfo]
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLikeRaw = "feels_like"
        case windSpeed = "wind_speed"
        case humidityRaw = "humidity"
        case cloudsRaw = "clouds"
        case weatherInfo = "weather"
        case sunriseRaw = "sunrise"
        case sunsetRaw = "sunset"
        case uviRaw = "uvi"
        case visibilityRaw = "visibility"
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
    
    public var feelsLike: String {
        return "\(Int(round(self.feelsLikeRaw)))º"
    }
    
    public var wind: String {
        return "\(Int(round(self.windSpeed))) m/s"
    }
    
    public var humidity: String {
        return "\(Int(round(self.humidityRaw)))%"
    }
    
    public var clouds: String {
        return "\(Int(round(self.cloudsRaw)))%"
    }
    
    public var sunrise: String {
        return Date(timeIntervalSince1970: self.sunriseRaw).format(to: "HH:mm")
    }
    
    public var sunset: String {
        return Date(timeIntervalSince1970: self.sunsetRaw).format(to: "HH:mm")
    }
    
    public var uvi: String {
        return "\(Int(round(self.uviRaw)))"
    }
    
    public var visibility: String {
        return "\(self.visibilityRaw / 1000) km"
    }
    
    public func icon(completion: @escaping (UIImage?) -> ()) -> () {
        if let weather = self.weatherInfo.first {
            return weather.icon(completion: completion)
        }
        
        completion(nil)
    }
}
