// 
//  MainBuilder.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 22.07.2021.
//

import UIKit

final class MainBuilder {
    
    public static func build() -> MainViewController {
        let view = MainViewController()
        let router = MainRouter(view: view)
        let presenter = MainPresenter(view: view, router: router)
        
        view.tabBarItem = .init(title: "Main", image: nil, tag: 0)
        
        view.presenter = presenter
        
        return view
    }
    
}
