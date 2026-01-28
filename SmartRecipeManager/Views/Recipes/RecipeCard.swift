//
//  RecipeCard.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import Foundation

import SwiftUI

struct RecipeCard: View {
    
    let recipe: Recipe
    
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {

            imageSection
            
            
            Text(recipe.name)
                .font(.headline)
                .lineLimit(1)
            
            HStack {
                Text(recipe.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if recipe.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            Button(action: {
                        viewModel.toggleFavoritefromAPI(recipe) // Toggle favorite
                        }) {
                            HStack {
                                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(recipe.isFavorite ? .red : .gray)
                                Text("Favorite")
                                    .foregroundColor(recipe.isFavorite ? .red : .gray)
                            }
                            .padding()
                            .background(Capsule().stroke(Color.gray, lineWidth: 1))
                        }        }
        .padding()
        .background(.thinMaterial)
        //.cornerRadius(16)
        .clipShape(RoundedRectangle(cornerRadius: 16))    .animation(.easeInOut(duration: 0.3), value: recipe.isFavorite)
    }
}

/*private extension RecipeCard {

    var imageSection: some View {
        Group {
            if let urlString = recipe.imageURL,
               let url = URL(string: urlString) {

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        placeholderImage

                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
        .frame(height: 160)
        .clipped()
    }

    var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .padding(40)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}*/

private extension RecipeCard {

    var imageSection: some View {
        Group {
            if let urlString = recipe.imageURL,
               let url = URL(string: urlString) {

                AsyncImage(url: url, transaction: .init(animation: .easeInOut)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        placeholderImage

                    @unknown default:
                        placeholderImage
                    }
                }

            } else {
                placeholderImage
            }
        }
        .frame(height: 140)           // ✅ FIX HEIGHT
        .frame(maxWidth: .infinity)   // ✅ LOCK WIDTH
        .clipped()                   // ✅ unchanged
    }

    var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .padding(40)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
