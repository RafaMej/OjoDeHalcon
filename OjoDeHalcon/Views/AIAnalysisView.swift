//
//  AIAnalysisView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//
import SwiftUI

struct AIAnalysisView: View {
    @State private var isAnalyzing = false
    
    var body: some View {
        ZStack {
            AppTheme.tacticalBlack.ignoresSafeArea()
            
            VStack {
                if !isAnalyzing {
                    VStack(spacing: 32) {
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: CGFloat(20), style: .continuous)
                                .fill(AppTheme.championBurgundy.opacity(0.3))
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(AppTheme.whiteSharp)
                        }
                        
                        VStack(spacing: 6) {
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
                        
                        .padding(.bottom, 90)
                        Button(action: { isAnalyzing = true }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Iniciar Análisis")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(AppTheme.tacticalBlack)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.gloryGold)
                            .cornerRadius(12)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 60)
                        .padding(.bottom, 90)
                    }
                } else {
                    LiveAnalysisView(isAnalyzing: $isAnalyzing)
                }
            }
        }
    }
}

struct LiveAnalysisView: View {
    @Binding var isAnalyzing: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                // Match Score Header
                HStack {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("EN VIVO")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(16)
                    
                    Text("90+3'")
                        .foregroundColor(AppTheme.whiteSharp)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(AppTheme.whiteSharp)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .foregroundColor(AppTheme.whiteSharp)
                    }
                }
                .padding()
                
                HStack {
                    VStack {
                        Text("Argentina")
                            .foregroundColor(AppTheme.whiteSharp)
                        Text("2")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.championBurgundy)
                    }
                    
                    Text("VS")
                        .foregroundColor(AppTheme.whiteSharp.opacity(0.5))
                    
                    VStack {
                        Text("Francia")
                            .foregroundColor(AppTheme.whiteSharp)
                        Text("1")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.gloryGold)
                    }
                }
                .padding()
                .background(AppTheme.tacticalBlack.opacity(0.8))
                .cornerRadius(16)
                
                Spacer()
                
                // AI Insight Card
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(AppTheme.aiCyan)
                    Text("Análisis IA")
                        .foregroundColor(AppTheme.aiCyan)
                        .fontWeight(.bold)
                    Text("71:30")
                        .foregroundColor(AppTheme.whiteSharp)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.tacticalBlack)
                        .cornerRadius(8)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.tacticalBlack.opacity(0.9))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Francia reorganizando la defensa tras pérdida de balón")
                        .foregroundColor(AppTheme.whiteSharp)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.tacticalBlack.opacity(0.9))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            
            VStack {
                Spacer()
                Button(action: { isAnalyzing = false }) {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("Detener Análisis")
                    }
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding()
                    .background(AppTheme.championBurgundy)
                    .cornerRadius(12)
                }
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    AIAnalysisView()
}
