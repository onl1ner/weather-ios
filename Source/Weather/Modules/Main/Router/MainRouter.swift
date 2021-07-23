// 
//  MainRouter.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 22.07.2021.
//

import UIKit

protocol MainRouterProtocol {
    func showSearch(with delegate: SearchDelegate) -> ()
    init(view: MainViewController)
}

final class MainRouter: MainRouterProtocol {
    
    private weak var view: MainViewController?
    
    public func showSearch(with delegate: SearchDelegate) -> () {
        let view = SearchBuilder.build(with: delegate)
        self.view?.present(view, animated: true)
    }
    
    init(view: MainViewController) {
        self.view = view
    }
}
