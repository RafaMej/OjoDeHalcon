// OjoDeHalcon/Views/MainTabView.swift

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 2
    
    var body: some View {
        ZStack {
            AppTheme.gloryGold.ignoresSafeArea()
            
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
                
                AnalystView()
                    .tabItem {
                        
                        Label("Análisis IA", systemImage: "camera.fill")
                    }
    
                    .tag(2)
                
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }
                    .tag(3)
                
                TranscriptionView()
                    .tabItem {
                        Label("Traducción", systemImage: "globe")
                    }
                    .tag(4)
            }
            .accentColor(AppTheme.gloryGold) 
        }
    }
}

#Preview {
    MainTabView()
}
