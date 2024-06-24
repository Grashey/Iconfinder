//
//  SearchRoute.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 24.06.2024.
//

import Foundation

enum SearchRoute {
    case search
    case file
}

extension SearchRoute: Route {
    
    var url: String {
        switch self {
        case .search: return EndPoint.search
        case .file: return ""
        }
    }
}
