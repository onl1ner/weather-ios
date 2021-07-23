// 
//  MainPresenter.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 22.07.2021.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func searchButtonPressed() -> ()
    func retrieveWeather() -> ()
    
    init(view: MainViewControllerProtocol, router: MainRouterProtocol)
}

final class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewControllerProtocol?
    private var router: MainRouterProtocol
    
    private var weather: Weather?
    
    private func process(weather: Weather) -> () {
        self.view?.set(temperature: weather.temperature)
        self.view?.set(weather: weather.weather)
        self.view?.set(wind: weather.wind)
        self.view?.set(humidity: weather.humidity)
        
        weather.icon { image in
            self.view?.set(image: image)
        }
    }
    
    private func process(error: AppError) -> () {
        print(error.title, error.message)
    }
    
    public func searchButtonPressed() -> () {
        self.router.showSearch(with: self)
    }
    
    public func retrieveWeather() -> () {
        self.view?.showLoading()
        
        Location.shared.location { result in
            switch result {
                case .success(let response):
                    let location = response.location
                    let city = response.city
                    
                    self.view?.set(city: city)
                    
                    let lat = location.coordinate.latitude
                    let lon = location.coordinate.longitude
                    
                    Network.shared.getCurrentWeather(for: lat, lon: lon) { result in
                        self.view?.stopLoading()
                        
                        switch result {
                            case .success(let weather): self.process(weather: weather)
                            case .failure(let error): self.process(error: error)
                        }
                    }
                case .failure(let error): self.process(error: error)
            }
        }
    }
    
    init(view: MainViewControllerProtocol, router: MainRouterProtocol) {
        self.view = view
        self.router = router
    }
}

extension MainPresenter: SearchDelegate {
    
    public func didSelect() -> () {
        self.retrieveWeather()
    }
    
}
