//
//  IconResponse.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 24.06.2024.
//

import Foundation

struct IconResponse: Decodable {
    let totalCount: Int
    let icons: [Icon]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case icons
    }
}

struct Icon: Decodable {
    let iconID: Int
    let tags: [String]
    let rasterSizes: [RasterSize]
    
    enum CodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case tags
        case rasterSizes = "raster_sizes"
    }
}

struct RasterSize: Decodable {
    let formats: [FormatElement]
    let size, sizeWidth, sizeHeight: Int

    enum CodingKeys: String, CodingKey {
        case formats, size
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
    }
}

struct FormatElement: Decodable {
    let format: String
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case format
        case imageUrl = "download_url"
    }
}
