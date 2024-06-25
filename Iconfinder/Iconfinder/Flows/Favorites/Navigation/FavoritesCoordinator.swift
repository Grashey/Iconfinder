//
//  FavoritesCoordinator.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import UIKit

class FavoritesCoordinator: iCoordinator {
    
    private var navigation: UINavigationController?
    private let assembly: iAssembly

    init(with navigation: UINavigationController?, assembly: iAssembly) {
        self.navigation = navigation
        self.assembly = assembly
    }
    
    func start() {
        guard let controller = assembly.build(.favorites) as? FavoritesViewController else { return }
        navigation?.viewControllers = [controller]
    }
}
