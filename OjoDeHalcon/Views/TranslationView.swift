//
//  TranslationView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 14/10/25.
//
import SwiftUI

struct TranslationView: View {
    @State private var selectedLanguage = "Español"
    @State private var isTranslating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.tacticalBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(AppTheme.whiteSharp)
                            Text("Traducción Global")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.whiteSharp)
                            Spacer()
                        }
                        .padding()
                        
                        HStack {
                            Text("Tiempo Real")
                                .foregroundColor(AppTheme.whiteSharp)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppTheme.championBurgundy)
                        .cornerRadius(16)
                        
                        LanguageSelector(selectedLanguage: $selectedLanguage)
                        MatchSelector()
                        TranslationControls(isTranslating: $isTranslating)
                        LiveCommentsSection()
                    }
                    .padding()
                }
            }
        }
    }
}

struct LanguageSelector: View {
    @Binding var selectedLanguage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "translate")
                    .foregroundColor(AppTheme.aiCyan)
                Text("Idioma de traducción")
                    .foregroundColor(AppTheme.whiteSharp)
            }
            
            Menu {
                Button("Español") { selectedLanguage = "Español" }
                Button("English") { selectedLanguage = "English" }
                Button("Português") { selectedLanguage = "Português" }
            } label: {
                HStack {
                    Text("🇪🇸")
                    Text(selectedLanguage)
                        .foregroundColor(AppTheme.whiteSharp)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppTheme.whiteSharp)
                }
                .padding()
                .background(AppTheme.tacticalBlack.opacity(0.5))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.3))
        .cornerRadius(12)
    }
}

struct MatchSelector: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .foregroundColor(AppTheme.aiCyan)
                Text("Seleccionar partido")
                    .foregroundColor(AppTheme.whiteSharp)
            }
            
            MatchCard(
                flag1: "🇦🇷", team1: "Argentina",
                flag2: "🇫🇷", team2: "Francia",
                status: "FINAL",
                score: "3 - 3",
                time: "120'",
                stage: "Final Mundial"
            )
            
            MatchCard(
                flag1: "🇧🇷", team1: "Brasil",
                flag2: "🇭🇷", team2: "Croacia",
                status: "EN VIVO",
                score: "1 - 1",
                time: "45'",
                stage: "Cuartos de Final"
            )
        }
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.3))
        .cornerRadius(12)
    }
}

struct MatchCard: View {
    let flag1: String
    let team1: String
    let flag2: String
    let team2: String
    let status: String
    let score: String
    let time: String
    let stage: String
    
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 8) {
                    Text(flag1)
                    Text(team1)
                        .foregroundColor(AppTheme.whiteSharp)
                    Text("vs")
                        .foregroundColor(AppTheme.whiteSharp.opacity(0.5))
                    Text(team2)
                        .foregroundColor(AppTheme.whiteSharp)
                    Text(flag2)
                }
                
                Spacer()
                
                Text(status)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(status == "EN VIVO" ? Color.red : Color.blue)
                    .cornerRadius(8)
            }
            
            HStack {
                Text(stage)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
                    .font(.caption)
                Spacer()
                Text(score)
                    .foregroundColor(AppTheme.whiteSharp)
                    .fontWeight(.bold)
                Text(time)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppTheme.aiCyan, lineWidth: 2)
        )
    }
}

struct TranslationControls: View {
    @Binding var isTranslating: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "pause.fill")
                .foregroundColor(AppTheme.whiteSharp)
            Image(systemName: "speaker.wave.2.fill")
                .foregroundColor(AppTheme.whiteSharp)
            Text("Reproduciendo")
                .foregroundColor(AppTheme.whiteSharp)
            Spacer()
            
            HStack {
                Text("🇪🇸")
                Text(isTranslating ? "Traduciendo" : "Traducir")
                    .foregroundColor(AppTheme.aiCyan)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppTheme.tacticalBlack)
            .cornerRadius(20)
            .onTapGesture {
                isTranslating.toggle()
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.3))
        .cornerRadius(12)
    }
}

struct LiveCommentsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .foregroundColor(AppTheme.aiCyan)
                Text("Comentarios en Vivo")
                    .foregroundColor(AppTheme.whiteSharp)
                Spacer()
                Text("LIVE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            
            CommentCard(
                time: "1'",
                player: "Messi",
                text: "Pase brillante de Messi rompe la defensa",
                originalText: "Original (English): Brilliant pass from Messi splits the defense"
            )
            
            CommentCard(
                time: "23'",
                player: "Messi",
                text: "¡GOL! ¡Messi anota un tiro libre magnífico!",
                originalText: "Original (English): GOAL! Messi scores a magnificent free kick!"
            )
        }
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.3))
        .cornerRadius(12)
    }
}

struct CommentCard: View {
    let time: String
    let player: String
    let text: String
    let originalText: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(AppTheme.aiCyan)
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(time)
                        .font(.caption)
                }
                .foregroundColor(AppTheme.whiteSharp)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(player)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.aiCyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppTheme.aiCyan.opacity(0.2))
                    .cornerRadius(8)
                
                Text(text)
                    .foregroundColor(AppTheme.whiteSharp)
                
                Text(originalText)
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.5))
                    .italic()
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppTheme.aiCyan.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview{
    TranslationView()
}
