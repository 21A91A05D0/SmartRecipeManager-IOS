//
//  FeaturedRecipeCard.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import Foundation

import SwiftUI

/*struct FeaturedRecipeCard: View {
    
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Rectangle()
                .fill(Color.orange.opacity(0.3))
                .frame(height: 120)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                )
                .cornerRadius(16)
            
            Text(recipe.name)
                .font(.headline)
                .lineLimit(1)
            
            Text("\(recipe.cookingTime) mins")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 180)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}*/

struct FeaturedRecipeCard: View {

    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            imageSection

            Text(recipe.name)
                .font(.headline)
                .lineLimit(1)

            Text("\(recipe.cookingTime) mins")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 180)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .clipShape(RoundedRectangle(cornerRadius: 20)) // 🔑 HARD CLIP
        .shadow(radius: 4)
    }
}

private extension FeaturedRecipeCard {

    var imageSection: some View {
        ZStack {
            if let imageURL = recipe.imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.orange.opacity(0.3)
                        .overlay(
                            ProgressView()
                        )
                }
            } else {
                Color.orange.opacity(0.3)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    )
            }
        }
        .frame(height: 120)           // ✅ FIX HEIGHT
        .frame(maxWidth: .infinity)   // ✅ LOCK WIDTH
        .clipped()                    // ✅ PREVENT OVERFLOW
        .cornerRadius(16)
    }
}
