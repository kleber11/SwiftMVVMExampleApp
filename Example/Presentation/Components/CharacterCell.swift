//
//  CharacterCell.swift
//  Example
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import SwiftUI

/// View with `Character`.
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
            Spacer()
            VStack(spacing: .zero) {
                Text(character.name)
                    .font(.title)
                Text(character.status)
                    .font(.headline)
                Text(character.gender)
                    .font(.footnote)
            }
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
    }
}
