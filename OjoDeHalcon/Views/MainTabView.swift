//
//  MainTabView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 2
    @State private var showAIAnalysis = false
    
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
                
                AnalystViewWithCameraButton(showAIAnalysis: $showAIAnalysis)
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
        .fullScreenCover(isPresented: $showAIAnalysis) {
            AIAnalysisView()
        }
    }
}

// MARK: - Analyst View con Botón de Cámara

struct AnalystViewWithCameraButton: View {
    @Binding var showAIAnalysis: Bool
    
    var body: some View {
        ZStack {
            // Tu vista original de Analyst
            AnalystView()
            
            // Botón centrado superpuesto
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 480) // Empuja el botón hacia abajo
                
                // Botón grande y atractivo
                Button(action: {
                    print("🎥 Abriendo AIAnalysisView")
                    showAIAnalysis = true
                }) {
                    VStack(spacing: 16) {
                        // Ícono de cámara
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.gloryGold, AppTheme.gloryGold.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 60)
                                .shadow(color: AppTheme.gloryGold.opacity(0.5), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "video.fill")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(AppTheme.tacticalBlack)
                        }
                        
                        // Texto del botón
                        VStack(spacing: 4) {
                            Text("Iniciar Análisis con Cámara")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("Detecta jugadores y tácticas en vivo")
                                .font(.caption)
                                .opacity(0.8)
                        }
                        .foregroundColor(AppTheme.whiteSharp)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.tacticalBlack.opacity(0.95))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [AppTheme.gloryGold, AppTheme.aiCyan],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
        }
    }
}

#Preview {
    MainTabView()
}
