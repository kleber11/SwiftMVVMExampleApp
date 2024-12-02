//
//  NetworkError.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

///
public enum NetworkError: Error {
    
    ///
    case missingURL
    
    ///
    case serializationError
    
    ///
    case invalidStatusCode(Int)
    
    ///
    case decodingError(Error)
    
    ///
    case castError

    ///
    var localizedDescription: String {
        return ""
    }
}
