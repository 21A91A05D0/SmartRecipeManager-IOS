//
//  ShoppingItem.swift
//  SmartRecipeManager
//
//  Created by RPS on 26/01/26.
//

import Foundation

struct ShoppingItem: Identifiable {
    let id = UUID()
    let name: String
    var isChecked: Bool = false
}
