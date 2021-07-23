// 
//  MainPresenter.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 22.07.2021.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func retrieveWeather() -> ()
    
    init(view: MainViewControllerProtocol, router: MainRouterProtocol)
}

final class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewControllerProtocol?
    private var router: MainRouterProtocol
    
    public func retrieveWeather() -> () {
        self.view?.showLoading()
        
        Location.shared.location { location, city in
            if let location = location,
               let city = city {
                self.view?.stopLoading()
                self.view?.set(city: city)
            }
            
        }
    }
    
    init(view: MainViewControllerProtocol, router: MainRouterProtocol) {
        self.view = view
        self.router = router
    }
}
