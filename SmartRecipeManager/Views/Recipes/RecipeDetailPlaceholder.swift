//
//  RecipeDetailPlaceholder.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import Foundation

import SwiftUI

struct RecipeDetailPlaceholder: View {
    
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 20) {
            Text(recipe.name)
                .font(.largeTitle)
                .bold()
            
            Text("Detail screen coming next ")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
    }
}
