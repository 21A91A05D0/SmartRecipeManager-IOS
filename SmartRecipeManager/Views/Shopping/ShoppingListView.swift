//
//  ShoppingListView.swift
//  SmartRecipeManager
//
//  Created by RPS on 26/01/26.
//

import SwiftUI

struct ShoppingListView: View {

    @ObservedObject var viewModel: RecipeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                headerSection

                if viewModel.shoppingList.isEmpty {
                    emptyState
                } else {
                    shoppingItems
                }
            }
            .padding()
        }
        .navigationTitle("Shopping List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !viewModel.shoppingList.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        viewModel.clearShoppingList()
                    }
                }
            }
        }
    }
}

private extension ShoppingListView {

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🛒 Shopping List")
                .font(.title2)
                .fontWeight(.bold)

            Text("Check items as you buy them")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ShoppingListView {

    var shoppingItems: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.shoppingList) { item in
                ShoppingItemRow(
                    item: item,
                    toggleAction: {
                        viewModel.toggleShoppingItem(item)
                    }
                )
            }

        }
    }
}

private extension ShoppingListView {

    var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "cart")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("No Items Yet")
                .font(.headline)

            Text("Generate a shopping list from a recipe")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.top, 60)
    }
}
