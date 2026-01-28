//
//  FavoritesView.swift
//  SmartRecipeManager
//
//  Created by RPS on 26/01/26.
//

import SwiftUI

struct FavoritesView: View {

    @ObservedObject var viewModel: RecipeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                headerSection

                if viewModel.favoriteRecipes.isEmpty {
                    emptyState
                } else {
                    favoritesGrid
                }
            }
            .padding()
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension FavoritesView {

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("❤️ Favorite Recipes")
                .font(.title2)
                .fontWeight(.bold)

            Text("Your go-to dishes")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension FavoritesView {

    var favoritesGrid: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 160))],
            spacing: 16
        ) {
            ForEach(viewModel.favoriteRecipes) { recipe in
                NavigationLink {
                    RecipeDetailView(viewModel: viewModel, recipe: recipe, isFromAPI: true)
                } label: {
                    RecipeCard(recipe: recipe, viewModel: viewModel)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
    }
}


private extension FavoritesView {

    var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "heart")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("No Favorites Yet")
                .font(.headline)

            Text("Tap ❤️ on a recipe to add it here")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.top, 60)
    }
}




