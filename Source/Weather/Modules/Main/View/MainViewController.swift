// 
//  MainViewController.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 22.07.2021.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func set(city: String) -> ()
    func set(hint: String) -> ()
    func set(image: UIImage?) -> ()
    func set(weather: String) -> ()
    func set(temperature: String) -> ()
    
    func showLoading() -> ()
    func stopLoading() -> ()
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    @IBOutlet private weak var mainStackView: UIStackView!
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var hintLabel: UILabel!
    
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherLabel: UILabel!
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    @IBOutlet private weak var refreshButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var tableView: UITableView!
    
    public var presenter: MainPresenterProtocol!
    
    @IBAction private func refreshButtonPressed(_ sender: UIButton) -> () {
        self.presenter.retrieveWeather()
    }
    
    @IBAction private func searchButtonPressed(_ sender: UIButton) -> () {
        self.presenter.searchButtonPressed()
    }
    
    public func set(city: String) -> () {
        self.cityLabel.text = city
    }
    
    public func set(hint: String) -> () {
        self.hintLabel.text = hint
    }
    
    public func set(image: UIImage?) {
        self.weatherImageView.image = image
    }
    
    public func set(weather: String) -> () {
        self.weatherLabel.text = weather
    }
    
    public func set(temperature: String) -> () {
        self.temperatureLabel.text = temperature
    }
    
    public func showLoading() -> () {
        self.activityIndicator.startAnimating()
        self.refreshButton.isEnabled = false
        
        UIView.animate(withDuration: 0.2) {
            self.mainStackView.alpha = 0.0
        }
    }
    
    public func stopLoading() -> () {
        self.activityIndicator.stopAnimating()
        self.refreshButton.isEnabled = true
        
        UIView.animate(withDuration: 0.2) {
            self.mainStackView.alpha = 1.0
        }
    }
    
    override public func viewDidLoad() -> () {
        super.viewDidLoad()
        self.presenter.retrieveWeather()
    }
}
