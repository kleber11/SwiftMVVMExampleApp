//
//  Router.swift
//  PageLoader
//
//  Created by Vladyslav Vcherashnii on 11/18/24.
//

import Foundation
import SwiftUI

/// Enumeration with available paths to go.
enum AppRoute {
    
    /// Home page
    case home
    /// Details page
    case details
}

/// Protocol definition of `Router` pattern.
protocol Router {
    
    /// `NavigationPath` bindings
    var path: Binding<NavigationPath> { get }
    
    /// Executes navigatio to specific route
    /// - Parameter route: Specific route to be open
    func navigate(to route: AppRoute)
    
    /// Executes pop back action
    func pop()
}

/// Default implementation of `Router`.
final class DefaultRouterImplementation: Router {
    
    // MARK: - Published properties

    @Published
    var navigationPath = NavigationPath()

    // MARK: - Computed properties

    var path: Binding<NavigationPath> {
        Binding(get: {
            self.navigationPath
        }, set: {
            self.navigationPath = $0
        })
    }
    
    // MARK: - Conformance: Router
    
    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }
    
    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
}

