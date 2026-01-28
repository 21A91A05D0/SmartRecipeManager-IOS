//
//  CoreDataMapper.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//


//import CoreData

/*extension RecipeEntity {
    func toRecipe() -> Recipe {
        Recipe(
            id: id ?? UUID(),
            name: name ?? "",
            category: category ?? "Other",
            cookingTime: Int(cookingTime),
            difficulty: difficulty,
            instructions: instructions as? [String] ?? [],
            ingredients: (ingredients as? Set<IngredientEntity>)?
                .map { $0.toIngredient() } ?? [],
            isFavorite: isFavorite,
            createdAt: createdAt ?? Date(),
            imageURL: imageURL ?? ""
        )
    }
}

extension IngredientEntity {
    func toIngredient() -> Ingredient {
        Ingredient(
            id: id ?? UUID(),
            name: name ?? "",
            quantity: quantity ?? ""
        )
    }
}*/

import CoreData

extension RecipeEntity {
    func toRecipe() -> Recipe {
        // Ensure imageURL is correctly mapped from CoreData to the Recipe model
        let ingredientsArray =
                    (ingredients as? Set<IngredientEntity>)?
                        .map { $0.toIngredient() } ?? []
        
        return Recipe(
            id: id ?? UUID(),
            name: name ?? "",
            category: category ?? "Other",
            cookingTime: Int(cookingTime),
            difficulty: difficulty,
            instructions: instructions as? [String] ?? [],
            ingredients: ingredientsArray,
            isFavorite: isFavorite,
            createdAt: createdAt ?? Date(),
            imageURL: imageURL ?? "", // Add the imageURL field here
            isCooked: isCooked 
        )
    }
}

extension IngredientEntity {
    func toIngredient() -> Ingredient {
        Ingredient(
            id: id ?? UUID(),
            name: name ?? "",
            quantity: quantity ?? ""
        )
    }
}
