//
//  RecipeDetailView.swift
//  SmartRecipeManager
//
//  Created by RPS on 26/01/26.
//

import SwiftUI

struct RecipeDetailView: View {

    @ObservedObject var viewModel: RecipeViewModel
    let recipe: Recipe
    
    let isFromAPI: Bool
    @State private var currentStep = 0
    @State private var showShare = false
    
    var isPersisted: Bool {
        viewModel.recipes.contains(where: { $0.id == recipe.id })
    }

    @State private var goToShoppingList = false
    
    @State private var showEditScreen = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                heroSection

                infoSection
                
                if isFromAPI {
                    Button {
                        viewModel.saveAPIRecipeToMyRecipes(recipe)
                    } label: {
                        Label("Add to My Recipes", systemImage: "tray.and.arrow.down.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Button {
                    viewModel.toggleCookedStatus(recipe)
                } label: {
                    Label(
                        recipe.isCooked ? "Marked as Cooked" : "Mark as Cooked",
                        systemImage: recipe.isCooked ? "checkmark.circle.fill" : "circle"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(recipe.isCooked ? .green : .blue)

                ingredientsSection

                stepsSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                favoriteButton
                
                shareButton
                
            
                    Button {
                        showEditScreen = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    
                    // DELETE
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                
            }
            ToolbarItem(placement: .bottomBar) {
                    Button {
                        viewModel.generateShoppingList(from: [recipe])
                        goToShoppingList = true
                    } label: {
                        Label("Shopping List", systemImage: "cart.badge.plus")
                    }
            }
            
        }
        .alert("Delete Recipe?",
               isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteRecipeWithUndo(recipe)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action can be undone for a short time.")
        }
        .navigationDestination(isPresented: $goToShoppingList) {
            ShoppingListView(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $showEditScreen) {
            AddEditRecipeView(
                viewModel: viewModel,
                recipeToEdit: recipe
            )
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: [recipe.name])
        }
    }
}

/*private extension RecipeDetailView {

    var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.orange.opacity(0.25))
                .frame(height: 220)

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text("\(recipe.cookingTime) mins • \(recipe.category)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}*/

private extension RecipeDetailView {

    var heroSection: some View {
        ZStack(alignment: .bottomLeading) {

            // Image or fallback
            if let urlString = recipe.imageURL,
               let url = URL(string: urlString) {

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        fallbackHero

                    @unknown default:
                        fallbackHero
                    }
                }
            } else {
                fallbackHero
            }

            // Title overlay
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("\(recipe.cookingTime) mins • \(recipe.category)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.black.opacity(0.7), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
        }
        .frame(height: 240)
        .cornerRadius(24)
        .clipped()
    }

    var fallbackHero: some View {
        Color.orange.opacity(0.3)
    }
}

private extension RecipeDetailView {

    var infoSection: some View {
        HStack(spacing: 12) {
            infoChip(icon: "clock", text: "\(recipe.cookingTime) mins")
            infoChip(icon: "gauge", text: "Level \(Int(recipe.difficulty))")
        }
    }

    func infoChip(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.thinMaterial)
            .cornerRadius(12)
    }
}

private extension RecipeDetailView {

    var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Ingredients")
                .font(.headline)

            if recipe.ingredients.isEmpty {
                Text("No ingredients added.")
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                ForEach(recipe.ingredients) { ingredient in
                    HStack {
                        Text("• \(ingredient.name)")
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}




private extension RecipeDetailView {
    
    private var hasSteps: Bool {
        !recipe.instructions.isEmpty
    }

    var stepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Text("Steps")
                    .font(.headline)

                Spacer()

                Text("\(currentStep + 1)/\(recipe.instructions.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if hasSteps {
                ProgressView(
                    value: Double(currentStep + 1),
                    total: Double(recipe.instructions.count)
                )
            }

            if hasSteps {
                Text(recipe.instructions[currentStep])
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    .transition(.slide)
                    .animation(.easeInOut(duration: 0.25), value: currentStep)
            } else {
                Text("No cooking steps added yet.")
                    .foregroundColor(.secondary)
                    .padding()
            }

            Button(action: nextStep) {
                Text(
                    hasSteps && currentStep < recipe.instructions.count - 1
                    ? "Next Step"
                    : "Done"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(hasSteps ? Color.accentColor : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .disabled(!hasSteps)

        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(24)
    }

    func nextStep() {
        guard hasSteps else { return }

        if currentStep < recipe.instructions.count - 1 {
            currentStep += 1
        }
    }

}

private extension RecipeDetailView {

    var favoriteButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                viewModel.toggleFavorite(recipe)
            }
        } label: {
            Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .scaleEffect(recipe.isFavorite ? 1.2 : 1.0)
        }

    }

    var shareButton: some View {
        Button {
            showShare = true
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
}

