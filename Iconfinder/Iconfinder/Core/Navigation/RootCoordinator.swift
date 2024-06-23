//
//  Coordinator.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

protocol iCoordinator {
    func start()
}

final class RootCoordinator: iCoordinator {
    
    private let window: UIWindow?
    private lazy var tabBarCoordinator = TabBarCoordinator(window: window)

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        tabBarCoordinator.start()
    }
}
