//
//  DIContainer.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import Foundation

enum CDModel: String {
    case favorites = "Favorites"
    case cache = "Cache"
}

class Container {
    
    static let shared = Container()
    private init() {}

    lazy var favorites = CoreDataStack(model: CDModel.favorites)
    lazy var cache = CoreDataStack(model: CDModel.cache)
}
