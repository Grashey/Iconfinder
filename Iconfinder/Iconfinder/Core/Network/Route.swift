//
//  Route.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 24.06.2024.
//

import Foundation

protocol Route {
    var method: String { get }
    var url: String { get }
}

extension Route {
    var method: String { "GET" }

    func makeURL(_ path: String? = nil) -> String {
        guard let path = path else { return url }
        return path
    }
}
