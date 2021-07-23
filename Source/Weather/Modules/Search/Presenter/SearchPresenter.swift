// 
//  SearchPresenter.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import MapKit
import Foundation

protocol SearchDelegate {
    func didSelect() -> ()
}

protocol SearchPresenterProtocol: AnyObject {
    func numberOfRows() -> Int
    func text(for indexPath: IndexPath) -> String
    
    func didSelectRow(at indexPath: IndexPath) -> ()
    
    func textDidChange(to text: String) -> ()
    func didUpdate(results: [MKLocalSearchCompletion]) -> ()
    
    init(view: SearchViewControllerProtocol, delegate: SearchDelegate?)
}

final class SearchPresenter: SearchPresenterProtocol {
    
    private weak var view: SearchViewControllerProtocol?
    private var delegate: SearchDelegate?
    
    private var completer: MKLocalSearchCompleter = .init()
    private var results: [MKLocalSearchCompletion] = .init()
    
    public func numberOfRows() -> Int {
        return self.results.count
    }
    
    public func text(for indexPath: IndexPath) -> String {
        return self.results[indexPath.row].title
    }
    
    public func didSelectRow(at indexPath: IndexPath) -> () {
        let result = self.results[indexPath.row]
        let request = MKLocalSearch.Request(completion: result)
        
        MKLocalSearch(request: request).start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            
            Location.shared.set(lat: coordinate.latitude, lon: coordinate.longitude)
            self.delegate?.didSelect()
            
            self.view?.dismiss()
        }
    }
    
    public func textDidChange(to text: String) -> () {
        self.completer.queryFragment = text
    }
    
    public func didUpdate(results: [MKLocalSearchCompletion]) -> () {
        self.results = results
        self.view?.reloadData()
    }
    
    init(view: SearchViewControllerProtocol, delegate: SearchDelegate?) {
        self.view = view
        self.delegate = delegate
        
        self.completer.delegate = self.view
    }
}
