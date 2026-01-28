//
//  APIRecipesView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import SwiftUI

struct APIRecipesView: View {

    @ObservedObject var viewModel: RecipeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                headerSection

                fetchButton

                if viewModel.isFetchingFromAPI {
                    loadingView
                } else if viewModel.apiRecipes.isEmpty {
                    emptyState
                }
                else {
                    recipesScrollView
                }
            }
            .padding()
        }
        .navigationTitle("API Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error",
               isPresented: .constant(viewModel.apiErrorMessage != nil)) {
            Button("OK") {
                viewModel.apiErrorMessage = nil
            }
        } message: {
            Text(viewModel.apiErrorMessage ?? "")
        }
    }
}

private extension APIRecipesView {

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("✨ Recipe Inspiration")
                .font(.title2)
                .fontWeight(.bold)

            Text("Discover recipes from the web")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private extension APIRecipesView {

    var fetchButton: some View {
        Button {
            viewModel.fetchRandomRecipesFromAPI()
        } label: {
            Label("Fetch Recipes", systemImage: "sparkles")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

private extension APIRecipesView {

    var loadingView: some View {
        ProgressView("Fetching recipes...")
            .frame(maxWidth: .infinity)
            .padding(.top, 40)
    }
}

private extension APIRecipesView {

    var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "fork.knife")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("No Recipes Yet")
                .font(.headline)

            Text("Tap “Fetch Recipes” to get inspiration")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

private extension APIRecipesView {

    var recipesScrollView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Results")
                .font(.headline)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.apiRecipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(
                                viewModel: viewModel,
                                recipe: recipe,
                                isFromAPI: true                            )
                        } label: {
                            RecipeCard(recipe: recipe, viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }
}
