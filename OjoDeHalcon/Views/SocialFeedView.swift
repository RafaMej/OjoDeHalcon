//
//  SocialFeedView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

import SwiftUI

struct SocialFeedView: View {
    @State private var selectedFilter = 0
    let filters = ["Todo", "Tendencias", "Noticias"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.tacticalBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        ForEach(0..<filters.count, id: \.self) { index in
                            FilterChip(
                                text: filters[index],
                                isSelected: selectedFilter == index,
                                action: { selectedFilter = index }
                            )
                        }
                        .padding()
                    }
                    .padding()
                    
                    EmptyStateView(
                        icon: "globe",
                        title: "No hay contenido disponible",
                        subtitle: "Selecciona tus equipos favoritos para ver contenido personalizado"
                    )
                }
            }
            .navigationTitle("Social Feed")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FilterChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if text == "Tendencias" {
                    Image(systemName: "flame.fill")
                }
                Text(text)
            }
            .font(.subheadline)
            .fontWeight(isSelected ? .bold : .regular)
            .foregroundColor(isSelected ? AppTheme.tacticalBlack : AppTheme.whiteSharp)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? AppTheme.championBurgundy : AppTheme.tacticalBlack.opacity(0.3))
            .cornerRadius(20)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(AppTheme.whiteSharp.opacity(0.3))
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppTheme.whiteSharp)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

#Preview {
    SocialFeedView()
}

