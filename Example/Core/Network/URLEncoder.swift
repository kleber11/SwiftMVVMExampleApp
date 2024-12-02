//
//  URLEncoder.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

/// Default Implementation of URL encoding.
struct URLEncoder: ParameterEncoding {
    
    // MARK: - Conformance: ParameterEncoding
    
    func encode(
        _ request: inout URLRequest,
        parameters: [String : Any]?,
        headers: [String : Any]?
    ) throws {
        guard let url = request.url else { throw NetworkError.missingURL }
        
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let parameters, !parameters.isEmpty {
            let queryItems: [URLQueryItem] = parameters.map({ .init(name: $0.key, value: "\($0.value)")})
            components.queryItems = queryItems
            request.url = components.url
        }
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers, !headers.isEmpty {
            for (header, value) in headers {
                request.setValue("\(value)", forHTTPHeaderField: header)
            }
        }
    }
}
