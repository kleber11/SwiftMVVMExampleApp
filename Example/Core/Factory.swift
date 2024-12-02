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
    func createViewModel() -> ListViewModel {
        let useCase = DefaultListViewUseCase()
        let vm = ListViewModel(useCase: useCase)
        return vm
    }
}
