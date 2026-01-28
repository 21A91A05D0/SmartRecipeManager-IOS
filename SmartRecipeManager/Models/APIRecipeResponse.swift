//
//  APIRecipeResponse.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import Foundation

struct APIRecipeResponse: Codable {
    let meals: [APIRecipe]
}

