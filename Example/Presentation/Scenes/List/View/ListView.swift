//
//  ListView.swift
//  PageLoader
//
//  Created by Vladyslav Vcherashnii on 11/18/24.
//

import SwiftUI

/// Main list view implementing the UI
struct ListView<ViewModel: ListViewModeling>: View {
    
    // MARK: - Properties
    
    /// ViewModel
    @StateObject
    private var viewModel: ViewModel
    
    /// Coordinator
    @ObservedObject
    var coordinator: AppCoordinator
    
    // MARK: - Life cycle
    
    /// Initialize the view with provided `AppCoordinator` and `ViewModel`
    /// - Parameters:
    ///    - viewModel: ViewModel containing business logic
    ///    - coordinator: `AppCoordinator` responsible for navigation.
    init(viewModel: @autoclosure @escaping () -> ViewModel, coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.coordinator = coordinator
    }
    
    var body: some View {
        NavigationStack(path: coordinator.router.path) {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.items) { character in
                        CharacterCell(character: character)
                            .onTapGesture {
                                viewModel.didSelectItem(character)
                            }
                            .task {
                                await viewModel.loadMoreIfNeeded(currentItem: character)
                            }
                    }
                    if viewModel.state == .loading && !viewModel.items.isEmpty {
                        ProgressView()
                            .frame(height: 50)
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .navigationTitle("Characters")
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .details:
                    if let selectedCharacter = viewModel.items.last {
                        DetailsView(
                            viewModel: DetailsViewModel(character: selectedCharacter),
                            coordinator: coordinator
                        )
                    }
                case .home:
                    EmptyView()
                }
            }
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}

// MARK: - Supporting Views

struct CharacterCell: View {
    
    // MARK: - Properties
    
    /// `Character` object to be displayed.
    let character: Character
    
    // MARK: - Life cycle
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
                    .frame(width: 120, height: 120)
            }
            
            VStack(spacing: .zero) {
                Text(character.name)
                    .font(.headline)
                Text(character.status)
                    .font(.footnote)
            }
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
    }
}

struct ErrorView: View {
    
    // MARK: - Properties
    
    /// Error description to be displayed in subtitle.
    let error: Error
    
    /// The `Try Again` action.
    let retryAction: () -> Void
    
    // MARK: - Life cycle
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Something went wrong")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Button("Retry", action: retryAction)
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
