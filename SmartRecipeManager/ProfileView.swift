//
//  ProfileView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import SwiftUI

struct ProfileView: View {

    @ObservedObject var viewModel: RecipeViewModel

    @AppStorage("username") private var username: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                profileHeader

                statsGrid

                settingsSection
            }
            .padding()
        }
        .navigationTitle("Profile")
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

private extension ProfileView {

    var profileHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 90, height: 90)
                .foregroundColor(.blue)

            Text(username.isEmpty ? "Guest" : username)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension ProfileView {

    var statsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
            statCard(
                title: "Total Recipes",
                value: viewModel.recipes.count,
                icon: "book.fill"
            )

            statCard(
                title: "Favorites",
                value: viewModel.recipes.filter { $0.isFavorite }.count,
                icon: "heart.fill"
            )

            statCard(
                title: "Cooked",
                value: viewModel.recipes.filter { $0.isCooked }.count,
                icon: "checkmark.circle.fill"
            )

        }
    }

    func statCard(title: String, value: Int, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)

            Text("\(value)")
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

private extension ProfileView {

    var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Settings")
                .font(.headline)

            // Dark Mode Toggle
            Toggle(isOn: $isDarkMode) {
                Label("Dark Mode", systemImage: "moon.fill")
            }

            Divider()

            // Logout Button
            Button(role: .destructive) {
                logout()
            } label: {
                Label("Logout", systemImage: "arrow.backward.square")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }

    func logout() {
        isLoggedIn = false
        username = ""
    }
}
