//
//  ListViewModel.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation
import SwiftUI

// MARK: - Protocols

@MainActor
protocol ListViewModeling: ObservableObject {
    var state: ListViewState { get }
    var items: [Character] { get }
    var error: Error? { get }
    
    func loadInitialData() async
    func loadMoreIfNeeded(currentItem: Character?) async
    func refresh() async
}

// MARK: - Implementation

@MainActor
final class ListViewModel: ListViewModeling {
    // MARK: - Published Properties
    
    @Published private(set) var state: ListViewState = .loading
    @Published private(set) var items: [Character] = []
    @Published private(set) var error: Error?
    
    // MARK: - Private Properties
    
    private let useCase: ListViewUseCase
    private var currentPage: Int = 1
    private var canLoadMorePages = true
    private var isLoadingPage = false
    
    // MARK: - Initialization
    
    init(useCase: ListViewUseCase = DefaultListViewUseCase()) {
        self.useCase = useCase
    }
    
    // MARK: - ListViewModeling
    
    func loadInitialData() async {
        guard items.isEmpty else { return }
        await loadData(reset: true)
    }
    
    func loadMoreIfNeeded(currentItem item: Character?) async {
        guard let item = item,
              !isLoadingPage,
              canLoadMorePages else { return }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -3)
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            await loadData()
        }
    }
    
    func refresh() async {
        await loadData(reset: true)
    }
    
    // MARK: - Private Methods
    
    private func loadData(reset: Bool = false) async {
        guard !isLoadingPage && (reset || canLoadMorePages) else { return }
        
        if reset {
            state = .idle
            items = []
            currentPage = 1
            canLoadMorePages = true
            error = nil
        }
        
        isLoadingPage = true
        state = .loading
        
        do {
            let response = try await useCase.execute(currentPage)
            
            if reset {
                items = response.results
            } else {
                items.append(contentsOf: response.results)
            }
            
            currentPage += 1
            canLoadMorePages = response.info.next != nil
            error = nil
            state = .loaded
            
        } catch {
            self.error = error
            state = .error(error)
        }
        
        isLoadingPage = false
    }
}

// MARK: - Supporting Types

enum ListViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(Error)
    
    static func == (lhs: ListViewState, rhs: ListViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
            (.loading, .loading),
            (.loaded, .loaded):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - View

/// Main list view implementing the UI
struct ListView<ViewModel: ListViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        contentView
            .task {
                await viewModel.loadInitialData()
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        List(viewModel.items) { character in
            CharacterCell(character: character)
                .task {
                    await viewModel.loadMoreIfNeeded(currentItem: character)
                }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .overlay {
            overlayView
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.state {
        case .loading where viewModel.items.isEmpty:
            ProgressView()
        case .error(let error):
            ErrorView(error: error, retryAction: {
                Task {
                    await viewModel.refresh()
                }
            })
        default:
            EmptyView()
        }
    }
}

// MARK: - Supporting Views

struct CharacterCell: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(character.name)
                .font(.headline)
            // Add more character details as needed
        }
        .padding(.vertical, 8)
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
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

// MARK: - Preview

#Preview {
    ListView(viewModel: ListViewModel())
}
