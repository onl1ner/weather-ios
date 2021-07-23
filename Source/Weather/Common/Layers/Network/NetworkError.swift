//
//  NetworkError.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import Foundation

enum NetworkError: Error {
    
    case `internal`
    case transport
    case retrieve
    
}
