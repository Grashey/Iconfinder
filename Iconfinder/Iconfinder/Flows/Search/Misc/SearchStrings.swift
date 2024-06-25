//
//  SearchStrings.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import Foundation

enum SearchStrings {
    
    enum Title {
        static let searchPlaceholder = "Введите запрос..."
        static let maxSize = "Размер:"
        static let tags = "Тэги:"
        static let download = "Нажмите, чтобы сохранить"
        static let main = "Поиск"
        static let noResults = "Нет результатов"
    }
    
    enum Image {
        static let add = "icon_favorites_add"
        static let remove = "icon_favorites_remove"
        static let defaultImage = "icon_default"
    }
    
    enum Alert {
        static let request = "Чтобы включить доступ к фотоальбому, перейдите в настройки"
        static let settings = "Настройки"
        static let cancel = "Отмена"
        static let success = "Файл сохранен"
    }
}
