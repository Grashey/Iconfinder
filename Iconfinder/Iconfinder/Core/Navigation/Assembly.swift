//
//  Assembly.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

protocol iAssembly {
    func build(_ moduleName: ModuleName) -> UIViewController
}

class Assembly: iAssembly {
    
    func build(_ moduleName: ModuleName) -> UIViewController {
        switch moduleName {
        case .search: return SearchFactory.build()
        case .favorites: return FavoritesFactory.build()
        }
    }
}
