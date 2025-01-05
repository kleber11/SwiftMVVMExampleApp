//
//  Networking.swift
//  PageLoader
//
//  Created by Vladyslav Vcherashnii on 11/18/24.
//

import Foundation

/// Requeste response containing decoded object or error.
public typealias ResultWithError<Model> = Result<Model, Error>

/// Base definition of API EndPoint.
public protocol EndPointType {
    
    /// Base URL to be sent request to.
    var baseURL: URL { get }
    
    /// Path component for the `baseURL`.
    var path: String { get }
    
    /// The method of the request.
    var httpMethod: HTTPMethod { get }
    
    /// The type of encoding for request
    var encoding: URLEncodingType { get }
}

/// The public enum of encoding types supported by request.
public enum URLEncodingType {
    
    /// `URL Encoding` type.
    /// - Parameters:
    ///  - parameters: Dictionary containing additional params.
    ///  - headers: Dictionary containing additional headers/
    case url(
        parameters: [String: Any],
        headers: [String: Any]?
    )
    
    /// `JSON Encoding` type.
    /// - Parameters:
    ///  - parameters: Dictionary containing additional params.
    ///  - headers: Dictionary containing additional headers/
    case json(
        parameters: [String: Any],
        headers: [String: Any]?
    )
    
    /// Executes encoing of provided `URLRequest` with specific paramateres and headers (if any).
    func encode(
        _ request: inout URLRequest,
        parameters: [String: Any]?,
        headers: [String: Any]?
    ) throws {
        do {
            switch self {
            case .url(let parameters, let headers):
                try URLEncoder().encode(&request, parameters: parameters, headers: headers)
            case .json(let parameters, let headers):
                try JSONEncoder().encode(&request, parameters: parameters, headers: headers)
            }
        } catch {
            throw error
        }
    }
}

/// Enum of available REST API methods.
public enum HTTPMethod: String {
    
    /// `GET` request.
    case `get` = "GET"
    
    /// `POST` request.
    case post = "POST"
}

/// Base network protocol which executes request.
public protocol Requestable<EndPoint>: AnyObject where EndPoint: EndPointType {

    /// Type of end point.
    associatedtype EndPoint: EndPointType
    
    /// Executes request
    /// - Parameter route: `EndPointType` object containing details about request.
    /// - Throws: Decodable `Model`.
    func request<Model: Decodable>(
        _ route: EndPoint
    ) async throws -> Model
}

/// Default implementation on `Networking`.
public final class DefaultNetworkService<EndPoint: EndPointType>: Requestable {
   
    /// The default timeout interval for request
    private let timeoutInterval = 10.0
    
    /// `URLSession` property.
    private let session: URLSession
    
    /// Basic init method.
    /// - Parameter session:
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Conformance: Requestable

    public func request<Model: Decodable>(_ route: EndPoint) async throws -> Model {
        let request = try buildRequest(from: route)
        let (data, response) = try await session.data(for: request)
        return try await handleResponse(data: data, response: response)
    }
    
    // MARK: - Helpers
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
            url: route.baseURL.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: timeoutInterval
        )
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.encoding {
            case .url(let params, let headers):
                try route.encoding.encode(&request, parameters: params, headers: headers)
            case .json(let parameters, let headers):
                try route.encoding.encode(&request, parameters: parameters, headers: headers)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func handleResponse<Model: Decodable>(data: Data, response: URLResponse) async throws -> Model {
        guard let response = response as? HTTPURLResponse else { throw NetworkError.castError }
        guard (200..<300).contains(response.statusCode) else { throw NetworkError.invalidStatusCode(response.statusCode) }
        do {
            let decodedModel = try JSONDecoder().decode(Model.self, from: data)
            return decodedModel
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

