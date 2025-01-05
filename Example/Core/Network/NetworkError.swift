//
//  NetworkError.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

/// Enum containing `Error` from networking.
enum NetworkError: Error {
    
    /// Throws when `URL` was not provided for a request.
    case missingURL
    
    /// Throws when decoder was not able to decode object.
    case serializationError
    
    /// Throws when request was not successfull
    /// - Returns `statusCode`.
    case invalidStatusCode(Int)
    
    /// Throws when decoder was not able to encode / decode object.
    /// - Returns `Error`.
    case decodingError(Error)
    
    /// Throws when `HTTPResponse` was not casted.
    case castError

    /// Localizations for each error.
    var localizedDescription: String {
        switch self {
        case .missingURL:
            return "Missing URL."
        case .serializationError:
            return "Could not serialize."
        case .invalidStatusCode(let statusCode):
            return "Request was not successfull. Finished with: \(statusCode) code."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .castError:
            return "Cast error. Check request."
        }
    }
}
