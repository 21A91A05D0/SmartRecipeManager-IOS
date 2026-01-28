//
//  ShoppingItemRow.swift
//  SmartRecipeManager
//
//  Created by RPS on 26/01/26.
//

import SwiftUI

struct ShoppingItemRow: View {

    let item: ShoppingItem
    let toggleAction: () -> Void

    var body: some View {
        HStack {

            Button(action: toggleAction) {
                Image(systemName: item.isChecked
                      ? "checkmark.circle.fill"
                      : "circle")
                    .foregroundColor(item.isChecked ? .green : .gray)
                    .font(.title2)
            }

            Text(item.name)
                .strikethrough(item.isChecked)
                .foregroundColor(item.isChecked ? .secondary : .primary)

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}


