//
//  OjoDeHalconApp.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

import SwiftUI
import Firebase

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
    
    func configureAppearance() {
   
        let appearance = UINavigationBarAppearance()
        
      
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppTheme.tacticalBlack)
        
       
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(AppTheme.whiteSharp)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.whiteSharp)]
   
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
