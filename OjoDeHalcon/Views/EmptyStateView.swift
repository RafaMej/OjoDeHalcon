//
//  EmptyStateView.swift
//  OjoDeHalcon
//
//  Created by Rosh on 17/10/25.
//
/*
import SwiftUI

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
                .foregroundStyle(AppTheme.whiteSharp.opacity(0.3))
                .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.whiteSharp)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.whiteSharp.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(
        icon: "soccerball",
        title: "Sin Contenido",
        subtitle: "No hay información disponible en este momento."
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppTheme.tacticalBlack)
}
*/
