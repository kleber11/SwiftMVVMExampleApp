//
//  DetailsViewModel.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

// MARK: - Details ViewModel Protocol

@MainActor
protocol DetailsViewModeling: ObservableObject {
    var character: Character { get }
    
    func loadDetails() async
}

// MARK: - Details ViewModel Implementation

@MainActor
final class DetailsViewModel: DetailsViewModeling {
    @Published private(set) var character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    func loadDetails() async {
        // Here you would typically load additional details
        // For now, we'll just use the character we already have
    }
}

// MARK: - Details View

struct DetailsView<ViewModel: DetailsViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    @ObservedObject var coordinator: AppCoordinator
    
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

// MARK: - Navigation Bar Back Button

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
