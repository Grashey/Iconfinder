//
//  FavoritesFactory.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import UIKit

enum FavoritesFactory {
    
   static func build() -> UIViewController {
       let controller = FavoritesViewController()
       let iconKeeper = Container.shared.favorites
       let presenter = FavoritesPresenter(iconKeeper: iconKeeper)
       controller.presenter = presenter
       presenter.viewController = controller
       return controller
    }
}
