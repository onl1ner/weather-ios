// 
//  SearchViewController.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import UIKit
import MapKit

protocol SearchViewControllerProtocol: MKLocalSearchCompleterDelegate {
    func reloadData() -> ()
    func dismiss() -> ()
}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    public var presenter: SearchPresenterProtocol!
    
    @objc private func cancelButtonPressed() -> () {
        self.dismiss()
    }
    
    @objc private func forceEndEditing() -> () {
        self.view.endEditing(true)
    }
    
    public func reloadData() -> () {
        self.tableView.reloadData()
    }
    
    public func dismiss() -> () {
        self.dismiss(animated: true)
    }
    
    override public func viewDidLoad() -> () {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let navigationItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonPressed))
        self.navigationItem.rightBarButtonItem = navigationItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forceEndEditing))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.textDidChange(to: searchText)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = self.presenter.text(for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectRow(at: indexPath)
    }
    
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) -> () {
        self.presenter.didUpdate(results: completer.results)
    }
    
}
