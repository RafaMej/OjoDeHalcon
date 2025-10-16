//
//  AuthenticationView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//
import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.championBurgundy, AppTheme.tacticalBlack],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Bienvenido a")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(AppTheme.whiteSharp)
                    
                    Text("MundialIA")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(AppTheme.gloryGold)
                }
                
                Text("Inicia sesión para personalizar tu experiencia")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack(spacing: 16) {
                    AuthButton(
                        icon: "applelogo",
                        text: "Continuar con Apple",
                        action: { signInWithApple() }
                    )
                    
                    AuthButton(
                        icon: "envelope.fill",
                        text: "Continuar con Email",
                        action: { signInWithEmail() }
                    )
                }
                
                Text("Al continuar, aceptas nuestros términos y condiciones")
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 60)
        }
    }
    
    func signInWithApple() {
        appState.isAuthenticated = true
    }
    
    func signInWithEmail() {
        appState.isAuthenticated = true
    }
}

struct AuthButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(text)
                    .fontWeight(.semibold)
            }
            .foregroundColor(AppTheme.whiteSharp)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.tacticalBlack)
            .cornerRadius(12)
        }
    }
}

#Preview {
    AuthenticationView()
}
