//
//  DetailsViewModel.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

/// `ViewModel` with details for `Character`.
protocol DetailsViewModeling: ObservableObject {
    
    /// `Character` to be displayed.
    var character: Character { get }
    
    /// Executes loading details for provided `Character`.
    func loadDetails() async
}

/// Default implementation of `DetailsViewModel`
final class DetailsViewModel: DetailsViewModeling {
    
    // MARK: - Conformance: - DetailsViewModeling
    // MARK: - Properties
    
    /// `Character` object to be displayed.
    @Published
    private(set) var character: Character
    
    // MARK: - Life cycle
    
    /// Initializes object with provided `Character`.
    /// - Parameter character: `Character` to be displayed.
    init(character: Character) {
        self.character = character
    }
    
    @MainActor
    func loadDetails() async {
        // Here you would typically load additional details
        // For now, we'll just use the character we already have
    }
}
