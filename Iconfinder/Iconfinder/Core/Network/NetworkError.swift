//
//  NetworkError.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 24.06.2024.
//

import Foundation

enum NetworkError: Error {
    case client(code: Int)
    case server(code: Int)
    case response
    case data
    case unknown(code: Int)

    var message: String {
        switch self {
        case .client(let code):
            return "\(code): Ошибка клиента"
        case .server(let code):
            return "\(code): Ошибка сервера"
        case .response:
            return "Сервер не отвечает"
        case .data:
            return "Данные отсутствуют"
        case .unknown(let code):
            return "\(code): Неизвестная ошибка"
        }
    }
}
