//
//  NetworkError.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import Foundation

enum NetworkError: Error, AppError {
    
    case `internal`
    case transport
    case retrieve
    
    public var title: String {
        switch self {
            case .internal: return "Внутренняя ошибка"
            case .transport: return "Ошибка отправки"
            case .retrieve: return "Ошибка получения"
        }
    }
    
    public var message: String {
        switch self {
            case .internal: return "Произошла внутренняя ошибка, попробуйте еще раз"
            case .transport: return "Произошла ошибка при попытке отправить данные, попробуйте еще раз"
            case .retrieve: return "Не удалось получить данные от сервера, попробуйте еще раз"
        }
    }
}
