//
//  AppError.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import Foundation

protocol AppError {
    var title: String { get }
    var message: String { get }
}
