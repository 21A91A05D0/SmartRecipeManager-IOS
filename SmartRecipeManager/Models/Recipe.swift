//
//  Recipe.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var cookingTime: Int
    var difficulty: Double
    var instructions: [String]
    var ingredients: [Ingredient]
    var isFavorite: Bool
    var createdAt: Date
    let imageURL: String?
    var isCooked: Bool
}
