//
//  AddEditRecipeView.swift
//  SmartRecipeManager
//
//  Created by RPS on 25/01/26.
//
import SwiftUI
import PhotosUI

struct AddEditRecipeView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RecipeViewModel

    let recipeToEdit: Recipe?

    // MARK: - Form State
    @State private var name = ""
    @State private var category = "Vegetarian"
    @State private var cookingTime = 10
    @State private var difficulty = 1.0
    @State private var instructionsText = ""
    @State private var ingredientsText = ""
    @State private var imageURL: String?
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isCooked: Bool = false
    
    init(
        viewModel: RecipeViewModel,
        recipeToEdit: Recipe?
    ) {
        self.viewModel = viewModel
        self.recipeToEdit = recipeToEdit

        _isCooked = State(initialValue: recipeToEdit?.isCooked ?? false)
    }

    private let categories = ["Vegetarian", "Vegan", "Dessert", "Other"]

    var body: some View {
        NavigationStack {
            Form {

                basicInfoSection
                ingredientsSection
                instructionsSection
                difficultySection
                imageSection
            }
            .navigationTitle(recipeToEdit == nil ? "Add Recipe" : "Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                loadExistingData()
            }
        }
    }
}

private extension AddEditRecipeView {

    var basicInfoSection: some View {
        Section("Basic Info") {
            TextField("Recipe Name", text: $name)

            Picker("Category", selection: $category) {
                ForEach(categories, id: \.self) {
                    Text($0)
                }
            }

            Stepper("Cooking Time: \(cookingTime) mins",
                    value: $cookingTime,
                    in: 5...180,
                    step: 5)
        }
    }
}

private extension AddEditRecipeView {

    var ingredientsSection: some View {
        Section("Ingredients (one per line)") {
            TextEditor(text: $ingredientsText)
                .frame(height: 100)
        }
    }
}

private extension AddEditRecipeView {

    var instructionsSection: some View {
        Section("Instructions (one step per line)") {
            TextEditor(text: $instructionsText)
                .frame(height: 120)
        }
    }
}

private extension AddEditRecipeView {

    var difficultySection: some View {
        Section("Difficulty") {
            Slider(value: $difficulty, in: 1...5, step: 1)
            Text("Level: \(Int(difficulty)) / 5")
                .foregroundColor(.secondary)
        }
    }
}

private extension AddEditRecipeView {
    
    var imageSection: some View {
        Section("Photo") {
            
            // Image Preview
            if let imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                }
            }
            
            PhotosPicker(
                selection: $selectedImage,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Select Image", systemImage: "photo")
            }
            .onChange(of: selectedImage) {
                handleImageSelection()
            }
        }
    }
    
    private func handleImageSelection() {
        guard let selectedImage else { return }
        
        Task {
            do {
                if let data = try await selectedImage.loadTransferable(type: Data.self) {
                    imageData = data
                    imageURL = saveImageToDisk(data)
                }
            } catch {
                print("Image load failed:", error)
            }
        }
    }
    
    private func saveImageToDisk(_ data: Data) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)

        do {
            try data.write(to: url)
            return url.absoluteString
        } catch {
            print("Failed to save image:", error)
            return nil
        }
    }
}






private extension AddEditRecipeView {

    func saveRecipe() {

        let ingredients = ingredientsText
            .split(separator: "\n")
            .map {
                Ingredient(
                    id: UUID(),
                    name: String($0),
                    quantity: ""
                )
            }

        let instructions = instructionsText
            .split(separator: "\n")
            .map { String($0) }

        let recipe =
        Recipe(
            id: recipeToEdit?.id ?? UUID(),
            name: name,
            category: category,
            cookingTime: cookingTime,
            difficulty: difficulty,
            instructions: instructions,
            ingredients: ingredients,
            isFavorite: recipeToEdit?.isFavorite ?? false,
            createdAt: recipeToEdit?.createdAt ?? Date(),
            imageURL: imageURL,
            isCooked: isCooked
        )

        if recipeToEdit == nil {
            viewModel.addRecipe(recipe)
        } else {
            viewModel.updateRecipe(recipe)
        }
    }
}


private extension AddEditRecipeView {

    func loadExistingData() {
        guard let recipe = recipeToEdit else { return }
        
        name = recipe.name
        category = recipe.category
        cookingTime = recipe.cookingTime
        difficulty = recipe.difficulty
        ingredientsText = recipe.ingredients.map(\.name).joined(separator: "\n")
        instructionsText = recipe.instructions.joined(separator: "\n")
        imageURL = recipe.imageURL
        isCooked = recipe.isCooked
    }
}




