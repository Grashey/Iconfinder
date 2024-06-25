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
       let presenter = FavoritesPresenter()
       controller.presenter = presenter
       presenter.viewController = controller
       return controller
    }
}
