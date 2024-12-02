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
        case .list(let page):
            return "/character/?page=\(page)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var encoding: URLEncodingType {
        return .url(parameters: [:], headers: [:])
    }
}

