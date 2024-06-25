//
//  DataKeeper.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import Foundation

protocol IconDataKeeper {
    func checkIcon(id: String) -> Bool
    func deleteAllIcons()
    func deleteIcon(id: String)
    func addIconEntity(id: String, date: Date, tags: String, size: String, imageData: Data)
}

protocol ImageDataKeeper {
    func checkImage(id: String) -> Data?
    func deleteAllImages()
    func deleteImage(id: String)
    func addImageEntity(id: String, imageData: Data)
}
