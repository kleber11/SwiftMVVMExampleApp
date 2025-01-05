//
//  CharactersAPI.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

/// Enum with available APIs
enum CharactersAPI {
    
    /// List of characters
    /// - Parameter page: Used for pagination
    case list(Int)
    
}

extension CharactersAPI: EndPointType {
    
    // MARK: - Conformance: EndPointType
    
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/character"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var encoding: URLEncodingType {
        switch self {
        case .list(let page):
            return .url(
                parameters: [
                    "page": page
                ],
                headers: nil
            )
        }
    }
}

