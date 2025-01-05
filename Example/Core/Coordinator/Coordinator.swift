//
//  Coordinator.swift
//  PageLoader
//
//  Created by Vladyslav Vcherashnii on 11/18/24.
//

import SwiftUI

/// Protocol definition of `Coordinator`
protocol Coordinator: ObservableObject {
    
    /// Router property
    var router: Router { get }
    
    /// Entry point to coordinator
    func start()
    
    /// Executes navigatio
    func handle(route: AppRoute)
    
    /// Perform `back` navigation action
    func handleBackAction()
}

/// Default implementation of `Coordinator`.
final class AppCoordinator: Coordinator {
    
    /// Router
    var router: Router
    
    /// Init method
    /// - Parameter router: `Router` object to be injected.
    init(router: Router) {
        self.router = router
    }
    
    // MARK: - Conformance: Coordinator
    
    func start() {
        router.navigate(to: .home)
    }

    func handle(route: AppRoute) {
        router.navigate(to: route)
    }
    
    func handleBackAction() {
        router.pop()
    }
}
