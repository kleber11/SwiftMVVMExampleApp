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
    
    /// Creates ViewModel for `ListView` screen
    /// - Parameter coordinator: `Coordinator` object which handles routing.
    func createListViewModel(coordinator: any Coordinator) -> ListViewModel
    
    /// Creates `DetailsView` screen with provided `Character`.
    /// - Parameter character: `Character` object to be displayed.
    func createDetailsViewModel(character: Character) -> DetailsViewModel
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
    
    func createListViewModel(coordinator: any Coordinator) -> ListViewModel {
        let useCase = DefaultListViewUseCase()
        let vm = ListViewModel(useCase: useCase, coordinator: coordinator)
        return vm
    }
    
    func createDetailsViewModel(character: Character) -> DetailsViewModel {
        return DetailsViewModel(character: character)
    }
}
