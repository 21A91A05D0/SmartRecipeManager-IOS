//
//  LoginView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import SwiftUI

/*struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showWelcomeAlert = false

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("username") private var savedUsername: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome Back!")
                    .font(.title)
                    .fontWeight(.bold)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack {
                    Button(action: loginUser) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { showSignUp = true }) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                NavigationLink("", destination: SignUpView(), isActive: $showSignUp)
            }
            .padding()
            .navigationTitle("Login")
            .alert(isPresented: $showWelcomeAlert) {
                Alert(title: Text("Welcome"), message: Text("Welcome, \(savedUsername)!"), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func loginUser() {
        if username == savedUsername && password == "password" { // Use stored username and a fixed password for simplicity
            isLoggedIn = true
            savedUsername = username
            showWelcomeAlert = true
        }
    }
}*/

import SwiftUI

struct LoginView: View {

    @State private var username = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showError = false

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("username") private var savedUsername = ""

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Text("🍽 Smart Recipe Manager")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Welcome back!")
                .font(.headline)
                .foregroundColor(.secondary)

            VStack(spacing: 16) {
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }

            Button {
                loginUser()
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                showSignUp = true
            } label: {
                Text("Don't have an account? Sign Up")
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .alert("Login Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Invalid username or password")
        }
    }

    private func loginUser() {
        guard !username.isEmpty, !password.isEmpty else {
            showError = true
            return
        }

        // Simple local auth (can replace later)
        savedUsername = username
        isLoggedIn = true   // 🔑 THIS triggers TabBarView safely
    }
}
