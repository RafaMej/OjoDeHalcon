//
//  ProfileView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//
import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.tacticalBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        ProfileHeaderView()
                        StatsCardsView()
                        FavoriteTeamsSection()
                        SettingsSection()
                    }
                    .padding()
                }
            }
            .navigationTitle("Usuario")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
#Preview {
    ProfileView()
}
struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(AppTheme.championBurgundy)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(AppTheme.whiteSharp)
                    )
                
                Circle()
                    .fill(AppTheme.gloryGold)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "pencil")
                            .foregroundColor(AppTheme.tacticalBlack)
                            .font(.system(size: 14))
                    )
            }
            
            Text("Usuario MundialAI")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.whiteSharp)
            
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(AppTheme.gloryGold)
                Text("Aficionado Experto")
                    .foregroundColor(AppTheme.whiteSharp)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(AppTheme.championBurgundy)
            .cornerRadius(20)
        }
    }
}

struct StatsCardsView: View {
    var body: some View {
        HStack(spacing: 12) {
            StatCard(value: "12", label: "Partidos\nanalizados", color: AppTheme.championBurgundy)
            StatCard(value: "28", label: "Análisis\nguardados", color: AppTheme.gloryGold)
            StatCard(value: "7", label: "Días\nconsecutivos", color: AppTheme.championBurgundy)
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.whiteSharp)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.5))
        .cornerRadius(12)
    }
}

struct FavoriteTeamsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(AppTheme.championBurgundy)
                Text("Equipos Favoritos")
                    .font(.headline)
                    .foregroundColor(AppTheme.whiteSharp)
                Spacer()
                Button("Editar") {
                    // Navigate to team selection
                }
                .foregroundColor(AppTheme.gloryGold)
            }
            
            HStack {
                Text("🇲🇽 México")
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.championBurgundy)
                    .cornerRadius(16)
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.5))
        .cornerRadius(12)
    }
}

struct SettingsSection: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(AppTheme.gloryGold)
                Text("Configuración")
                    .font(.headline)
                    .foregroundColor(AppTheme.whiteSharp)
            }
            
            SettingsRow(icon: "bell.fill", title: "Notificaciones", subtitle: "Recibir alertas de partidos y noticias", isOn: $notificationsEnabled)
            SettingsRow(icon: "moon.fill", title: "Modo Oscuro", subtitle: "Apariencia de la aplicación", isOn: $darkModeEnabled)
        }
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.5))
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.gloryGold)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(AppTheme.whiteSharp)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(AppTheme.championBurgundy)
        }
    }
}
