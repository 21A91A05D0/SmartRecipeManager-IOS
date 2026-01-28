//
//  SmartRecipeManagerApp.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import SwiftUI

@main
struct SmartRecipeManagerApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            /*TabBarView()
             .environment(\.managedObjectContext,
             persistenceController.container.viewContext)*/
            if isLoggedIn {
                TabBarView()
                    .environment(\.managedObjectContext,
                                  persistenceController.container.viewContext)
            }
            else {
                LoginView()
            }
        }
    }
    
    /*if isLoggedIn {
     TabBarView()
     } else {
     LoginView()
     }*/
}
