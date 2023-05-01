//
//  APIManager.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 01/05/2023.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: APIRequest, authToken: String) async throws -> Data
    func requestToken() async throws -> Data
}

class APIManager: APIManagerProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: APIRequest, authToken: String = "") async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createURLRequest(authToken: authToken))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else { throw NetworkError.invalidServerResponse }
        
        return data
    }
    
    func requestToken() async throws -> Data {
        try await perform(AuthTokenRequest.auth)
    }
}
