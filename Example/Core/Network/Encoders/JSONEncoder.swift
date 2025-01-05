//
//  JSONEncoder.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

/// `JSONEncoder` which encodes provided parameters and headers into JSON representable object.
struct JSONEncoder: ParameterEncoding {
    
    // MARK: - Conformance: ParameterEncoding
    
    func encode(
        _ request: inout URLRequest,
        parameters: [String : Any]?,
        headers: [String : Any]?
    ) throws {
        guard let _ = request.url else { throw NetworkError.missingURL }
        do {
            if let parameters {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = jsonData
            }
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            if let headers, !headers.isEmpty {
                for (header, value) in headers {
                    request.setValue("\(value)", forHTTPHeaderField: header)
                }
            }
        } catch {
            throw NetworkError.serializationError
        }
    }
}
