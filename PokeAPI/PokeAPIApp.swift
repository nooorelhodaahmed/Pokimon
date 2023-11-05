//
//  PokeAPIApp.swift
//  PokeAPI
//
//  Created by norelhoda on 28/10/2023.
//

import SwiftUI

@main
struct PokeAPIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
