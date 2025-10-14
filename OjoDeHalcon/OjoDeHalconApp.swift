//
//  OjoDeHalconApp.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

import SwiftUI
//import Firebase

@main
struct OjoDeHalconApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        FirebaseApp.configure()
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
    
    private func configureAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(AppTheme.whiteSharp)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(AppTheme.whiteSharp)]
    }
}

