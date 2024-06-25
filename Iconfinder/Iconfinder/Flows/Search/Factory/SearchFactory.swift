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
       let iconKeeper = Container.shared.favorites
       let imageKeeper = Container.shared.cache
       let presenter = SearchPresenter(networkService: networkService, iconKeeper: iconKeeper, imageKeeper: imageKeeper)
       controller.presenter = presenter
       presenter.viewController = controller
       return controller
    }
}
