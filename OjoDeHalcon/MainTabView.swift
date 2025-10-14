//
//  MainTabView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 2
    
    var body: some View {
        ZStack {
            AppTheme.tacticalBlack.ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                SocialFeedView()
                    .tabItem {
                        Label("Noticias", systemImage: "newspaper")
                    }
                    .tag(0)
                
                ProfileView()
                    .tabItem {
                        Label("Perfil", systemImage: "person")
                    }
                    .tag(1)
                
                AIAnalysisView()
                    .tabItem {
                        Label("Análisis IA", systemImage: "camera.fill")
                    }
                    .tag(2)
                
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }
                    .tag(3)
                
                TranslationView()
                    .tabItem {
                        Label("Traducción", systemImage: "globe")
                    }
                    .tag(4)
            }
            .accentColor(AppTheme.gloryGold)
        }
    }
}
