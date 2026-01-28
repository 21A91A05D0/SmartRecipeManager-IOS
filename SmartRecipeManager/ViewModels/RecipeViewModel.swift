//
//  RecipeViewModel.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//


import Foundation
import CoreData
import Combine

final class RecipeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var sortOption: SortOption = .newest
    @Published var shoppingList: [ShoppingItem] = []
    
    @Published var isFetchingFromAPI = false
    @Published var apiErrorMessage: String?
    @Published var apiRecipes: [Recipe] = []

    @Published var recentlyDeletedRecipe: Recipe?
    @Published var showUndoDelete = false

    // MARK: - Private
    
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchRecipes()
        setupSearchPipeline()
    }
}

enum SortOption {
    case alphabetical
    case newest
}

extension RecipeViewModel {
    
    func fetchRecipes() {
        let request = RecipeEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        do {
            let result = try context.fetch(request)
            recipes = result.map { $0.toRecipe() }
        } catch {
            print("Fetch error:", error)
        }
    }
    
    func fetchRandomRecipesFromAPI(count: Int = 5) {
        isFetchingFromAPI = true
        apiErrorMessage = nil
        apiRecipes.removeAll()

        Task {
            do {
                for _ in 0..<count {
                    let recipe = try await RecipeAPIService.shared.fetchRandomRecipe()
                    await MainActor.run {
                        self.apiRecipes.append(recipe)
                    }
                }

                await MainActor.run {
                    self.isFetchingFromAPI = false
                }
            } catch {
                await MainActor.run {
                    self.apiErrorMessage = "Failed to fetch recipes"
                    self.isFetchingFromAPI = false
                }
            }
        }
    }


}

extension RecipeViewModel {
    
    private func setupSearchPipeline() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func deleteRecipe(id: UUID) {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
            fetchRecipes()
        } catch {
            print("Delete failed:", error)
        }
    }
  
}

extension RecipeViewModel {
    
    var filteredRecipes: [Recipe] {
        var result = recipes
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedCategory != "All" {
            result = result.filter {
                $0.category == selectedCategory
            }
        }
        
        switch sortOption {
        case .alphabetical:
            result.sort { $0.name < $1.name }
        case .newest:
            result.sort { $0.createdAt > $1.createdAt }
        }
        
        return result
    }
}

extension RecipeViewModel {

    // Function to add a new recipe
    func addRecipe(_ recipe: Recipe) {
        let entity = RecipeEntity(context: context)
        
        // Assign properties to RecipeEntity
        entity.id = recipe.id
        entity.name = recipe.name
        entity.category = recipe.category
        entity.cookingTime = Int16(recipe.cookingTime)
        entity.difficulty = recipe.difficulty
        entity.instructions = recipe.instructions as NSArray
        entity.isFavorite = recipe.isFavorite
        entity.createdAt = recipe.createdAt
        entity.imageURL = recipe.imageURL // Save imageURL
        entity.isCooked = recipe.isCooked

        // Create a mutable set to hold ingredients
        //let ingredientsSet = NSMutableSet()

        // Create IngredientEntity objects and add them to the set
        recipe.ingredients.forEach { ingredient in
            let ingEntity = IngredientEntity(context: context)
            ingEntity.id = ingredient.id
            ingEntity.name = ingredient.name
            ingEntity.quantity = ingredient.quantity
            ingEntity.recipe = entity  // Assign the inverse relationship to 'recipe'
            
            
            // Add the ingredient to the ingredients set
            //ingredientsSet.add(ingEntity)
        }

        // Assign the ingredients set to the 'ingredients' relationship in RecipeEntity
        //entity.addToIngredients(ingredientsSet)

        saveContext()
        fetchRecipes()
    }

    // Function to update an existing recipe
    func updateRecipe(_ recipe: Recipe) {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)

        do {
            if let entity = try context.fetch(request).first {
                entity.name = recipe.name
                entity.category = recipe.category
                entity.cookingTime = Int16(recipe.cookingTime)
                entity.difficulty = recipe.difficulty
                entity.instructions = recipe.instructions as NSArray
                entity.isFavorite = recipe.isFavorite
                entity.imageURL = recipe.imageURL // Update imageURL
                entity.isCooked = recipe.isCooked

                // Clear old ingredients
                if let existingIngredients = entity.ingredients as? Set<IngredientEntity> {
                    existingIngredients.forEach { context.delete($0) }
                }

                // Add updated ingredients
                let ingredientEntities = recipe.ingredients.map {
                    let ing = IngredientEntity(context: context)
                    ing.id = $0.id
                    ing.name = $0.name
                    ing.quantity = $0.quantity
                    ing.recipe = entity
                    return ing
                }

                // Assign the new ingredients to the entity
                entity.ingredients = NSSet(array: ingredientEntities)

                saveContext()
                fetchRecipes()
            }
        } catch {
            print("Update failed:", error)
        }
    }

    // Function to delete a recipe
    func deleteRecipeWithUndo(_ recipe: Recipe) {
        recentlyDeletedRecipe = recipe // Set the recently deleted recipe
        deleteRecipe(id: recipe.id)    // Perform the deletion from Core Data

        // Show undo bar
        showUndoDelete = true

        // Hide the undo bar after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showUndoDelete = false
            self.recentlyDeletedRecipe = nil
        }

    }

    // Undo function to restore deleted recipe
    func undoDelete() {
            guard let recipe = recentlyDeletedRecipe else { return }
            addRecipe(recipe) // Restore the deleted recipe
            recentlyDeletedRecipe = nil
            showUndoDelete = false
        }
}




extension RecipeViewModel {
    
    func toggleFavorite(_ recipe: Recipe) {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)
        
        if let entity = try? context.fetch(request).first {
            entity.isFavorite.toggle()
            saveContext()
            fetchRecipes()
        }
    }
    
    var favoriteRecipes: [Recipe] {
        recipes.filter { $0.isFavorite }
    }
}

extension RecipeViewModel {
    
    func generateShoppingList(from recipes: [Recipe]) {
        let ingredients = recipes
            .flatMap { $0.ingredients }
            .map { $0.name }

        let uniqueItems = Set(ingredients)

        shoppingList = uniqueItems.map {
            ShoppingItem(name: $0)
        }
    }

    
    func clearShoppingList() {
        shoppingList.removeAll()
    }

    
    func toggleShoppingItem(_ item: ShoppingItem) {
        if let index = shoppingList.firstIndex(where: { $0.id == item.id }) {
            shoppingList[index].isChecked.toggle()
        }
    }

}

extension RecipeViewModel {
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Save error:", error)
        }
    }
}


extension RecipeViewModel {

    // Function to save an API recipe to My Recipes (Core Data)
    func saveRecipeToMyRecipes(_ recipe: Recipe) {
        var newRecipe = recipe
        newRecipe.isFavorite = false  // Default as not favorite when saving from API
        addRecipe(newRecipe)  // Use existing addRecipe function to add to Core Data
    }

    // Function to toggle favorite status for both API and My Recipes
    func toggleFavoritefromAPI(_ recipe: Recipe) {
        var updatedRecipe = recipe
        updatedRecipe.isFavorite.toggle()  // Toggle favorite state
        updateRecipe(updatedRecipe)  // Use existing updateRecipe function to update Core Data
    }
    
    func saveAPIRecipeToMyRecipes(_ recipe: Recipe) {
        // Prevent duplicates
        if recipes.contains(where: { $0.name == recipe.name }) { return }

        var newRecipe = recipe
        newRecipe.isFavorite = false
        newRecipe.createdAt = Date()

        addRecipe(newRecipe)
    }
    
    func toggleCookedStatus(_ recipe: Recipe) {
        var updated = recipe
        updated.isCooked.toggle()
        updateRecipe(updated)
    }
}
