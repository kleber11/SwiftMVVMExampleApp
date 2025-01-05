//
//  ExampleApp.swift
//  Example
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

@main
struct ExampleApp: App {
    
    ///
    let factory: any Factory
    
    ///
    let coordinator: any Coordinator
    
    ///
    init(
        factory: (any Factory) = DefaultFactoryImplementation(),
        coordinator: (any Coordinator)?
    ) {
        self.factory = factory
        self.coordinator = coordinator ?? factory.createCoordinator()
    }
    
    ///
    init() {
        factory = DefaultFactoryImplementation()
        coordinator = factory.createCoordinator()
    }
    
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: ListViewModel(coordinator: coordinator))
        }
    }
}
