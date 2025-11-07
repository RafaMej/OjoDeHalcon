//
//  AIAnalysisView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

import SwiftUI

struct AIAnalysisView: View {
    @State private var showCameraAnalysis = false
    
    var body: some View {
        ZStack {
            AppTheme.tacticalBlack.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Hero Image/Icon
                ZStack {
                    Circle()
                        .fill(AppTheme.championBurgundy.opacity(0.3))
                        .frame(width: 200, height: 200)
                    
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(AppTheme.whiteSharp)
                }
                
                // Title and Description
                VStack(spacing: 16) {
                    Text("Análisis IA en Vivo")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.whiteSharp)
                    
                    Text("Apunta la cámara al partido para comenzar el análisis táctico en tiempo real")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.whiteSharp.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // Features List
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(
                        icon: "person.3.fill",
                        title: "Detección de Jugadores",
                        description: "Identifica jugadores en tiempo real"
                    )
                    
                    FeatureRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Análisis Táctico",
                        description: "Formaciones y movimientos"
                    )
                    
                    FeatureRow(
                        icon: "brain.head.profile",
                        title: "Insights IA",
                        description: "Recomendaciones inteligentes"
                    )
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Main Action Button - Abre la cámara
                Button(action: {
                    print("🎥 Abriendo cámara...")
                    showCameraAnalysis = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "video.fill")
                            .font(.title3)
                        Text("Abrir Cámara")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(AppTheme.tacticalBlack)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .padding(.horizontal)
                    .background(AppTheme.gloryGold)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .fullScreenCover(isPresented: $showCameraAnalysis) {
            LiveCameraAnalysisView(isPresented: $showCameraAnalysis)
        }
    }
}

// MARK: - Feature Row Component

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppTheme.aiCyan)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppTheme.whiteSharp)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.tacticalBlack.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.aiCyan.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    AIAnalysisView()
}
