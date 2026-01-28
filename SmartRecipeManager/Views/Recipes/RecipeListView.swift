//
//  RecipeListView.swift
//  SmartRecipeManager
//
//  Created by RPS on 25/01/26.
//

import SwiftUI

struct RecipeListView: View {

    @ObservedObject var viewModel: RecipeViewModel

    var body: some View {
        List {
            ForEach(viewModel.filteredRecipes) { recipe in
                /*NavigationLink {
                    RecipeDetailPlaceholder(recipe: recipe)
                } label: {
                    RecipeRow(recipe: recipe)
                }*/
                NavigationLink {
                    RecipeDetailView(viewModel: viewModel, recipe: recipe, isFromAPI: true)
                } label: {
                    RecipeCard(recipe: recipe, viewModel: viewModel) // or RecipeRow
                }
                .swipeActions(edge: .trailing) {
                    
                    Button(role: .destructive) {
                        viewModel.deleteRecipe(id: recipe.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("All Recipes")
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                sortMenu
            }
        }
    }
}

private extension RecipeListView {

    var sortMenu: some View {
        Menu {
            Button {
                viewModel.sortOption = .newest
            } label: {
                Label("Newest", systemImage: "clock")
            }

            Button {
                viewModel.sortOption = .alphabetical
            } label: {
                Label("Alphabetical", systemImage: "textformat")
            }

        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}
