//
//  SearchFactory.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

enum SearchFactory {
    
   static func build() -> UIViewController {
       let controller = SearchViewController()
       let networkService = SearchNetworkService()
       let presenter = SearchPresenter(networkService: networkService)
       controller.presenter = presenter
       presenter.viewController = controller
       return controller
    }
}
