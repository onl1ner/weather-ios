//
//  LocationError.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import Foundation

enum LocationError: Error, AppError {
    case `internal`
    case unauthorized
    
    case geocode
    case notDetermined
    
    public var title: String {
        switch self {
            case .internal: return "Внутренняя ошибка"
            case .unauthorized: return "Нет доступа"
            case .geocode, .notDetermined: return "Ошибка"
        }
    }
    
    public var message: String {
        switch self {
            case .internal: return "Произошла внутренняя ошибка, попробуйте еще раз"
            case .unauthorized: return "Мы не можем показать погоду с текущей геолокацией, т.к вы не предоставили доступ"
            case .geocode: return "Произошла ошибка при попытке найти город"
            case .notDetermined: return "Не удалось получить вашу геопозицию"
        }
    }
}
