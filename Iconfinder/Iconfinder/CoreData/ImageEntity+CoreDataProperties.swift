//
//  ImageEntity+CoreDataProperties.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageData: Data?

}

extension ImageEntity : Identifiable {

}
