//
//  TabBarCoordinator.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

class TabBarCoordinator: iCoordinator {
    
    private var window: UIWindow?
    private var controller: TabBarController
    private let assembly: iAssembly
    private lazy var searchCoordinator = SearchCoordinator(with: controller.searchNavigation, assembly: assembly)
    private lazy var favoritesCoordinator = FavoritesCoordinator(with: controller.favoritesNavigation, assembly: assembly)

    init(window: UIWindow?) {
        self.window = window
        self.controller = TabBarController()
        self.assembly = Assembly()
    }

    func start() {
        window?.rootViewController = controller
        searchCoordinator.start()
        favoritesCoordinator.start()
    }
}
