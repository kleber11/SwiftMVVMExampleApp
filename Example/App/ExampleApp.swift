//
//  ExampleApp.swift
//  Example
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

@main
struct ExampleApp: App {
    
    /// Factory instance
    let factory: any Factory
    
    /// Coordinator instance
    let coordinator: any Coordinator
    
    /// Initialization
    /// - Parameters:
    ///   - factory: The `Factory` incance with default implementation.
    ///   - coordinator: The `Coordinator` instance with default implementation
    init(
        factory: (any Factory) = DefaultFactoryImplementation(),
        coordinator: (any Coordinator)?
    ) {
        self.factory = factory
        self.coordinator = coordinator ?? factory.createCoordinator()
    }
    
    /// Default initialization
    init() {
        factory = DefaultFactoryImplementation()
        coordinator = factory.createCoordinator()
    }
    
    /// Entry point to the app
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: ListViewModel(coordinator: coordinator))
        }
    }
}
