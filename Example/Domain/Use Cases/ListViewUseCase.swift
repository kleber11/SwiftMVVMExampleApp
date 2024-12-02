//
//  ListViewUseCase.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

/// Use Case for retrieving data from API
protocol ListViewUseCase {
 
    /// Executes `GET` request to API.
    /// - Parameter page: The page to be loaded.
    func execute(_ page: Int) async throws -> APIResponse
}

/// Default implementation of `ListViewUseCase`.
struct DefaultListViewUseCase: ListViewUseCase {
    
    /// `NetworkService` property used for making API calls.
    private let network: DefaultNetworkService<CharactersAPI>
   
    /// Standard `init` method,
    /// - Parameter network: `NetworkService` to be injected.
    init(network: DefaultNetworkService<CharactersAPI> = DefaultNetworkService<CharactersAPI>()) {
        self.network = network
    }
    
    // MARK: - Conformance: ListViewUseCase
    
    func execute(_ page: Int) async throws -> APIResponse {
        try await network.request(.list(page))
    }
}
