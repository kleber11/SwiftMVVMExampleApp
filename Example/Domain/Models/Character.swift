//
//  Item.swift
//  ExampleApp
//
//  Created by Vladyslav Vcherashnii on 11/19/24.
//

import Foundation

/// Root API response object
struct APIResponse: Decodable {
    
    /// Property containing `Info` object.
    let info: Info
    
    /// Array of `Characters`.
    let results: [Character]

}

/// Info struct containing additional information about pages.
struct Info: Decodable {
    
    /// Page number
    let count: Int
    
    /// Number of pages
    let pages: Int
    
    /// Next page if available
    let next: String?
    
    /// Prev page if available
    let prev: String?
}

/// Struct containing info about `Character`.
struct Character: Decodable, Identifiable {
    
    /// Identifier of item
    let id: Int
    
    /// Characters name
    let name: String
    
    /// Characters status
    let status: String
    
    /// Character type
    let type: String
    
    /// Characters gender
    let gender: String
    
    /// Characters image
    let image: String
}
