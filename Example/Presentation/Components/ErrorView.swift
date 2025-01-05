//
//  ErrorView.swift
//  Example
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

/// The `ErrorView` which is presented when network request was not successfull.
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

