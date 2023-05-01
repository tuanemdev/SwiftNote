//
//  NetworkError.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 01/05/2023.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidServerResponse
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL string is malformed."
        case .invalidServerResponse:
            return "The server returned an invalid response."
        }
    }
}
