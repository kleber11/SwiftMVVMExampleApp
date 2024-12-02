//
//  ListViewModel.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation
import SwiftUI

@MainActor
protocol ListViewModeling: ObservableObject {
    var state: ListViewState { get }
    var items: [Character] { get }
    var error: Error? { get }
    
    func loadInitialData() async
    func loadMoreIfNeeded(currentItem: Character?) async
    func refresh() async
    func didSelectItem(_ item: Character)
}

// MARK: - Implementation

@MainActor
final class ListViewModel: ListViewModeling {
    // MARK: - Published Properties
    
    @Published private(set) var state: ListViewState = .idle
    @Published private(set) var items: [Character] = []
    @Published private(set) var error: Error?
    
    // MARK: - Private Properties
    
    private let useCase: ListViewUseCase
    private var currentPage: Int = 1
    private var canLoadMorePages = true
    private var isLoadingPage = false
    private let coordinator: any Coordinator

    // MARK: - Initialization
    
    init(useCase: ListViewUseCase = DefaultListViewUseCase(), coordinator: any Coordinator) {
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
        coordinator.handle(route: .details)
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
