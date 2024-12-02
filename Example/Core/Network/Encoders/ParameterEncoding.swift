//
//  ParameterEncoding.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

/// Encoding protocol.
public protocol ParameterEncoding {
    
    /// Performs encoding params and headers for specific request
    /// - Parameters:
    ///   - request: `URLRequest` to be encoded for.
    ///   - parameters: Contains `Dictionary` with given parameters for a request.
    ///   - headers: Contains `Dictioary` with given headers for a request.
    /// - Throws: Returns `NetworkingError`.
    func encode(
        _ request: inout URLRequest,
        parameters: [String: Any]?,
        headers: [String: Any]?
    ) throws
}
