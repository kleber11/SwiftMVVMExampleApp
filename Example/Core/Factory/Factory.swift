//
//  Factory.swift
//  PageLoader
//
//  Created by Vladyslav Vcherashnii on 11/18/24.
//

import Foundation

/// Factory
protocol Factory {
    
    /// Creates `Coordinator` object
    func createCoordinator() -> any Coordinator
    
    /// Creates `Router` object
    func createRouter() -> Router
    
    ///
    ///
    func createListViewModel(coordinator: any Coordinator) async -> ListViewModel
    
    ///
    ///
    func createDetailsViewModel(character: Character) async -> DetailsViewModel
}

class DefaultFactoryImplementation: Factory {
    
    // MARK: - Conformance: Factory
    
    func createRouter() -> Router {
        let router = DefaultRouterImplementation()
        return router
    }
    
    func createCoordinator() -> any Coordinator {
        let router = createRouter()
        let coordinator = AppCoordinator(router: router)
        return coordinator
    }
    
    @MainActor
    func createListViewModel(coordinator: any Coordinator) -> ListViewModel {
        let useCase = DefaultListViewUseCase()
        let vm = ListViewModel(useCase: useCase, coordinator: coordinator)
        return vm
    }
    
    @MainActor
    func createDetailsViewModel(character: Character) -> DetailsViewModel {
        return DetailsViewModel(character: character)
    }
}
