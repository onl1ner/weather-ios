// 
//  SearchBuilder.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import UIKit

final class SearchBuilder {
    
    public static func build(with delegate: SearchDelegate?) -> UINavigationController {
        let view = SearchViewController()
        let presenter = SearchPresenter(view: view, delegate: delegate)
        
        view.title = "Search"
        view.presenter = presenter
        
        return .init(rootViewController: view)
    }
    
}
