//
//  SearchNetworkService.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 24.06.2024.
//

import Foundation

protocol iSearchNetworkService {
    func searchPhotos(_ query: String?, page: Int) async throws -> Data
    func fetchFile(url: String) async throws -> Data
}

class SearchNetworkService: iSearchNetworkService {
    
    private let httpClient: iHTTPClient
    private let requestBuilder: iRequestBuilder
    
    init(httpClient: iHTTPClient = HTTPClient(), requestBuilder: iRequestBuilder = RequestBuilder()) {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
    }
    
    func searchPhotos(_ query: String?, page: Int) async throws -> Data {
        let pagination = 10
        let parameters = ["query": query ?? "",
                          "offset": String(page*pagination),
                          "count": "\(pagination)",
                          "premium": "false",
                          "vector": "false"]
        let request = requestBuilder.makeRequest(route: SearchRoute.search, parameters: parameters)
        let response = try await httpClient.send(request: request)
        return response.data
    }
    
    func fetchFile(url: String) async throws -> Data {
        let request = requestBuilder.makeRequest(route: SearchRoute.file, path: url)
        let response = try await httpClient.send(request: request)
        return response.data
    }
    
}
