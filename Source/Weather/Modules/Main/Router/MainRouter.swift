// 
//  MainRouter.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 22.07.2021.
//

import UIKit

protocol MainRouterProtocol {
    init(view: MainViewController)
}

final class MainRouter: MainRouterProtocol {
    
    private weak var view: MainViewController?
    
    init(view: MainViewController) {
        self.view = view
    }
}
