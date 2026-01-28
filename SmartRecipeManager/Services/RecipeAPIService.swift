//
//  RecipeAPIService.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import Foundation

final class RecipeAPIService {

    static let shared = RecipeAPIService()
    private init() {}

    private let baseURL = "https://www.themealdb.com/api/json/v1/1/"

    func fetchRandomRecipe() async throws -> Recipe {
        let url = URL(string: baseURL + "random.php")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(APIRecipeResponse.self, from: data)

        guard let meal = response.meals.first else {
            throw URLError(.badServerResponse)
        }

        return convertToRecipe(meal)
    }
}

private extension RecipeAPIService {

    func convertToRecipe(_ api: APIRecipe) -> Recipe {
        let ingredientNames = [
            api.strIngredient1,
            api.strIngredient2,
            api.strIngredient3,
            api.strIngredient4,
            api.strIngredient5
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }

        let ingredients = ingredientNames.map {
            Ingredient(id: UUID(), name: $0, quantity: "")
        }

        let instructions = api.strInstructions?
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty } ?? []

        return Recipe(
            id: UUID(),
            name: api.strMeal,
            category: api.strCategory ?? "Other",
            cookingTime: Int.random(in: 20...60),
            difficulty: Double.random(in: 2...4),
            instructions: instructions,
            ingredients: ingredients,
            isFavorite: false,
            createdAt: Date(),
            imageURL: api.strMealThumb, // Assign the image URL here
            isCooked: false
        )
    }

}





