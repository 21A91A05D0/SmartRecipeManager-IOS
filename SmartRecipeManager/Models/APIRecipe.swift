//
//  APIRecipe.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import Foundation

struct APIRecipe: Codable {

    let strMeal: String
    let strCategory: String?
    let strInstructions: String?
    let strMealThumb: String?

    // Ingredients (1–20)
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
}

