//
//  DetailsView.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

/// `DetailsView` with provided object.
struct DetailsView<ViewModel: DetailsViewModeling>: View {
    
    // MARK: - Properties
    
    /// `ViewModel` containing business logic.
    @StateObject
    private var viewModel: ViewModel
    
    /// `AppCoordinator` which is responsible for navigation.
    @ObservedObject
    var coordinator: AppCoordinator
    
    // MARK: - Life cycle
    
    /// Initialize method with provided parameters.
    /// - Parameters:
    ///    - viewModel: ViewModel containing business logic.
    ///    - coordinator: Responsible for navigation between views.
    init(viewModel: @autoclosure @escaping () -> ViewModel, coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.character.name)
                    .font(.title)
                    .padding(.horizontal)
            }
        }
        .navigationBarBackButton {
            coordinator.handleBackAction()
        }
        .task {
            await viewModel.loadDetails()
        }
    }
}

private extension View {
    func navigationBarBackButton(action: @escaping () -> Void) -> some View {
        self.navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: action) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            )
    }
}
