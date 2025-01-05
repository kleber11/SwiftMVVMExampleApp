//
//  ListView.swift
//  PageLoader
//
//  Created by Vladyslav Vcherashnii on 11/18/24.
//

import SwiftUI

/// Main list view implementing the UI
struct ListView<ViewModel>: View where ViewModel: ListViewModel {
    
    // MARK: - Properties
    
    /// ViewModel
    @ObservedObject
    private var viewModel: ViewModel
    
    /// Init
    /// - Parameter viewModel
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.items) { character in
                        CharacterCell(character: character)
                    }
                }
                .navigationTitle("Characters")
            }
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}
