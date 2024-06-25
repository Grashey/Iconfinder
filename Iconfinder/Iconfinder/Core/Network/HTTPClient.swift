//
//  HTTPClient.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 24.06.2024.
//

import Foundation

struct CoreRequest {
    let data: Data
}

protocol iHTTPClient {
    func send(request: URLRequest) async throws -> CoreRequest
}

final class HTTPClient: iHTTPClient {

    private let session = URLSession.shared
    private var handler: (data: Data?, response: URLResponse?, error: Error?)?

    func send(request: URLRequest) async throws -> CoreRequest {
        handler = try await data(from: request)
        let data = try httpResponse(handler)
        return CoreRequest(data: data)
    }
    
    private func data(from request: URLRequest) async throws -> (Data?, URLResponse?, Error?) {
        try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: request) { data, response, error in
                continuation.resume(returning: (data, response, error))
            }
            task.resume()
        }
    }

    private func httpResponse(_ handler: (data: Data?, response: URLResponse?, error: Error?)?) throws -> Data {
        if let error = handler?.error {
            throw error
        }
        guard let httpResponse = handler?.response as? HTTPURLResponse else {
            throw NetworkError.response
        }
        if (400..<500).contains(httpResponse.statusCode) {
            throw NetworkError.client
        }
        if (500..<600).contains(httpResponse.statusCode) {
            throw NetworkError.server
        }
        guard (200..<300).contains(httpResponse.statusCode), let data = handler?.data else {
            throw NetworkError.data
        }
        return data
    }
}
