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
    func set(weather: String) -> ()
    func set(temperature: String) -> ()
    func set(wind: String) -> ()
    func set(humidity: String) -> ()
    
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
    
    @IBOutlet private weak var windContainerView: UIView!
    @IBOutlet private weak var windLabel: UILabel!
    
    @IBOutlet private weak var humidityContainerView: UIView!
    @IBOutlet private weak var humidityLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    public var presenter: MainPresenterProtocol!
    
    @IBAction private func searchButtonPressed(_ sender: UIButton) -> () {
        
    }
    
    public func set(city: String) -> () {
        self.cityLabel.text = city
    }
    
    public func set(hint: String) -> () {
        self.hintLabel.text = hint
    }
    
    public func set(weather: String) -> () {
        self.weatherLabel.text = weather
    }
    
    public func set(temperature: String) -> () {
        self.temperatureLabel.text = temperature
    }
    
    public func set(wind: String) -> () {
        self.windLabel.text = wind
    }
    
    public func set(humidity: String) -> () {
        self.humidityLabel.text = humidity
    }
    
    public func showLoading() -> () {
        self.activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.mainStackView.alpha = 0.0
        }
    }
    
    public func stopLoading() -> () {
        self.activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.mainStackView.alpha = 1.0
        }
    }
    
    private func initialConfiguration() -> () {
        self.windContainerView.layer.cornerRadius = 12
        self.humidityContainerView.layer.cornerRadius = 12
    }
    
    override public func viewDidLoad() -> () {
        super.viewDidLoad()
        self.initialConfiguration()
    }
}
