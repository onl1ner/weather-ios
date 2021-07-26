//
//  Date.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 26.07.2021.
//

import Foundation

extension Date {
    
    public func format(to mask: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = mask
        return dateFormatter.string(from: self)
    }
    
}
