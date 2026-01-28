//
//  RecipeRow.swift
//  SmartRecipeManager
//
//  Created by RPS on 25/01/26.
//

import SwiftUI

struct RecipeRow: View {

    let recipe: Recipe

    var body: some View {
        HStack(spacing: 12) {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.25))
                .frame(width: 55, height: 55)
                .overlay(
                    Image(systemName: "fork.knife")
                        .foregroundColor(.green)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)

                Text("\(recipe.cookingTime) mins • \(recipe.category)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if recipe.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

