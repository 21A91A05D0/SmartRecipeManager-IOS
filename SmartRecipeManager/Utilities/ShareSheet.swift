//
//  ShareSheet.swift
//  SmartRecipeManager
//
//  Created by RPS on 26/01/26.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {

    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: Context) {}
}

