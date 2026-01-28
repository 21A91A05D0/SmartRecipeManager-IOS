//
//  HomeView.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import SwiftUI

struct HomeView: View {
    
    //@StateObject private var viewModel =RecipeViewModel(context: PersistenceController.shared.container.viewContext)
    @ObservedObject var viewModel: RecipeViewModel
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("username") private var savedUsername: String = ""

    @State private var showLogoutAlert = false
    @State private var isCooked = false
    
    private let categories = ["All", "Vegetarian", "Vegan", "Dessert"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        header
                        
                        featuredSection
                        
                        categoryPicker
                        
                        recipeGrid
                    }
                    .padding()
                }
                addRecipeButton
            }
            .navigationTitle("🍽 Recipes")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        RecipeListView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
                // for shopping list button
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        ShoppingListView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "cart")
                    }
                }
                // for favorites navigation
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        FavoritesView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "heart")
                    }
                }
                // for API button
                
            }
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                if viewModel.isFetchingFromAPI {
                    ProgressView("Fetching recipe...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .alert("Error",
                   isPresented: .constant(viewModel.apiErrorMessage != nil),
                   actions: {
                       Button("OK") {
                           viewModel.apiErrorMessage = nil
                       }
                   },
                   message: {
                       Text(viewModel.apiErrorMessage ?? "")
            })
            .overlay(alignment: .bottom) {
                if viewModel.showUndoDelete {
                    HStack {
                        Text("Recipe deleted")
                            .foregroundColor(.white)

                        Spacer()

                        Button("Undo") {
                            viewModel.undoDelete()
                        }
                        .foregroundColor(.yellow)
                    }
                    .padding()
                    .background(.black.opacity(0.85))
                    .cornerRadius(12)
                    .padding()
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: viewModel.showUndoDelete)
                }
            }

        }
        
    }
}
    



private extension HomeView {
    
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Good Cooking 👋")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("What are you making today?")
                .foregroundColor(.secondary)
        }
    }
}

private extension HomeView {
    
    var featuredSection: some View {
        Group {
                if !viewModel.favoriteRecipes.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Featured")
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.favoriteRecipes.prefix(5)) { recipe in
                                    FeaturedRecipeCard(recipe: recipe)
                                }
                                
                            }
                            /*Button {
                                viewModel.fetchRandomRecipeFromAPI()
                            } label: {
                                Label("Inspire Me", systemImage: "sparkles")
                            }
                            .buttonStyle(.borderedProminent)*/
                        }
                    }
                }
            }
        }
}

private extension HomeView {
    
    var categoryPicker: some View {
        Picker("Category", selection: $viewModel.selectedCategory) {
            ForEach(categories, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
    }
}

private extension HomeView {
    
    var recipeGrid: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 160))],
            spacing: 16
        ) {
            ForEach(viewModel.filteredRecipes) { recipe in
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

private extension HomeView {

    var addRecipeButton: some View {
        NavigationLink {
            AddEditRecipeView(viewModel: viewModel, recipeToEdit: nil)
        } label: {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(radius: 6)
        }
        .padding()
    }
}

private extension HomeView {

    var recipeGridOrEmptyState: some View {
        Group {
            if viewModel.filteredRecipes.isEmpty {
                emptyStateView
            } else {
                recipeGrid
            }
        }
        .animation(.easeInOut, value: viewModel.filteredRecipes.isEmpty)
    }
}

private extension HomeView {

    var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("No Recipes Yet")
                .font(.headline)

            Text("Tap + to add your first recipe")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
