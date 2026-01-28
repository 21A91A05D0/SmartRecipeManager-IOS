//
//  Ingredient.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import Foundation

struct Ingredient: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var quantity: String
    
}
