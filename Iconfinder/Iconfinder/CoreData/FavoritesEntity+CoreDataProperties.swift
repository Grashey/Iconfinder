//
//  FavoritesEntity+CoreDataProperties.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//
//

import Foundation
import CoreData


extension FavoritesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesEntity> {
        return NSFetchRequest<FavoritesEntity>(entityName: "FavoritesEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var tags: String?
    @NSManaged public var size: String?
    @NSManaged public var imageData: Data?

}

extension FavoritesEntity : Identifiable {

}
