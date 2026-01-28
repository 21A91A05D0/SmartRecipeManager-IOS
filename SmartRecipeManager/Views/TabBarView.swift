//
//  TabBarView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var viewModel = RecipeViewModel(context: PersistenceController.shared.container.viewContext)

    var body: some View {
        TabView {
            // Home Tab
            NavigationView {
                HomeView(viewModel: viewModel)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            // API Recipes Tab
            NavigationView {
                APIRecipesView(viewModel: viewModel)
            }
            .tabItem {
                Label("API Recipes", systemImage: "sparkles")
            }

            // Swift Charts (placeholder for now)
            NavigationStack {
                        ProfileView(viewModel: viewModel)
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
        }
    }
}
