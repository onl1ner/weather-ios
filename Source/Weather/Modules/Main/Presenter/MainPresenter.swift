// 
//  MainPresenter.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 22.07.2021.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewControllerProtocol, router: MainRouterProtocol)
}

final class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewControllerProtocol?
    private var router: MainRouterProtocol
    
    init(view: MainViewControllerProtocol, router: MainRouterProtocol) {
        self.view = view
        self.router = router
    }
}
