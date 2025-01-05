//
//  ListViewModel.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation
import SwiftUI

/// The state of the view.
enum ListViewState: Equatable {
    
    /// idle
    case idle
    
    /// Loading is in progress.
    case loading
    
    /// Loaded already.
    case loaded
    
    /// Error
    case error(Error)
    
    // MARK: - Conformance: Equatable
    
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

/// Protocol-definition for `ListViewModel`.
protocol ListViewModeling: ObservableObject {
    
    /// The state of view.
    var state: ListViewState { get }
    
    /// Array containing of items to be displayed.
    var items: [Character] { get }
        
    // MARK: - Functions
    
    /// Executes initial load of the items.
    func loadInitialData() async
    
    /// Executes lodaing of items with pagination.
    /// - Parameter
    func loadMoreIfNeeded(currentItem: Character?) async
    
    /// Clears items and make initial load call.
    func refresh() async
    
    /// Executes selection of provided item.
    /// - Parameter item: `Character` to be selected.
    func didSelectItem(_ item: Character)
}

final class ListViewModel: ListViewModeling {
    
    // MARK: - Published Properties
    
    @Published
    private(set) var state: ListViewState = .idle
    
    @Published
    private(set) var items: [Character] = []
    
    // MARK: - Private Properties
    
    /// `ListViewUseCase` containing API call.
    private let useCase: ListViewUseCase
    
    /// Current page loaded.
    private var currentPage: Int = 1
    
    /// Whether can perform one more load request.
    private var canLoadMorePages = true
    
    /// Whether loading is currently in progress.
    private var isLoadingPage = false
    
    /// `Coordinator` object responsible for navigation.
    private let coordinator: any Coordinator

    // MARK: - Initialization
    
    /// Initializer
    /// - Parameters:
    ///  - useCase: Contains call for API.
    ///  - coordinator: Responsible for navigation.
    init(
        useCase: ListViewUseCase = DefaultListViewUseCase(),
        coordinator: any Coordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
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
    
    func didSelectItem(_ item: Character) {
        coordinator.handle(route: .details(item))
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func loadData(reset: Bool = false) async {
        guard !isLoadingPage && (reset || canLoadMorePages) else { return }
        
        if reset {
            state = .idle
            items = []
            currentPage = 1
            canLoadMorePages = true
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
            state = .loaded
            
        } catch {
            state = .error(error)
        }
        
        isLoadingPage = false
    }
}
