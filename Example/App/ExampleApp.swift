//
//  ExampleApp.swift
//  Example
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

@main
struct ExampleApp: App {
    
    let factory = DefaultFactoryImplementation()
    
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: factory.createListViewModel(coordinator: factory.createCoordinator()), coordinator: factory.createCoordinator() as! AppCoordinator)
        }
    }
}
