//
//  SearchCoordinator.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

class SearchCoordinator: iCoordinator {
    
    private var navigation: UINavigationController?
    private let assembly: iAssembly

    init(with navigation: UINavigationController?, assembly: iAssembly) {
        self.navigation = navigation
        self.assembly = assembly
    }
    
    func start() {
        guard let controller = assembly.build(.search) as? SearchViewController else { return }
        navigation?.viewControllers = [controller]
    }
}
