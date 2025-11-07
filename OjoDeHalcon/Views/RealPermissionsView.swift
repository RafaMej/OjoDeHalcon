//
//  RealPermissionsView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 14/10/25.
//
import SwiftUI

struct RealPermissionsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var permissionManager = PermissionManager.shared
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            AppTheme.championBurgundy.ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(AppTheme.gloryGold)
                        Text("Transparencia y Confianza")
                            .foregroundColor(AppTheme.gloryGold)
                            .font(.caption)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(AppTheme.gloryGold.opacity(0.2))
                    .cornerRadius(20)
                }
                
                Text("Permisos Necesarios")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.whiteSharp)
                
                Text("Para ofrecerte la mejor experiencia de análisis")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 16) {
                    RealPermissionRow(
                        icon: "camera.fill",
                        title: "Cámara",
                        subtitle: "Necesaria para análisis de IA",
                        status: permissionManager.cameraStatus,
                        action: {
                            if permissionManager.cameraStatus == .notDetermined {
                                permissionManager.requestCameraPermission { _ in }
                            } else if permissionManager.cameraStatus == .denied {
                                showingAlert = true
                            }
                        }
                    )
                    
                    RealPermissionRow(
                        icon: "bell.fill",
                        title: "Notificaciones",
                        subtitle: "Alertas de partidos y noticias",
                        status: permissionManager.notificationStatus,
                        action: {
                            if permissionManager.notificationStatus == .notDetermined {
                                permissionManager.requestNotificationPermission { _ in }
                            } else if permissionManager.notificationStatus == .denied {
                                showingAlert = true
                            }
                        }
                    )
                }
                .padding()
                .background(AppTheme.tacticalBlack.opacity(0.3))
                .cornerRadius(16)
                
                if permissionManager.cameraStatus == .denied {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(AppTheme.gloryGold)
                        Text("Funcionalidad limitada")
                            .foregroundColor(AppTheme.gloryGold)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(AppTheme.gloryGold.opacity(0.2))
                    .cornerRadius(12)
                }
                
                Spacer()
                
                Button(action: {
                    appState.hasRequiredPermissions = true
                }) {
                    Text("Continuar a la App")
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.tacticalBlack)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.gloryGold)
                        .cornerRadius(12)
                }
                
                Text("Nunca compartimos tus datos sin tu consentimiento.")
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 40)
        }
        .alert("Permiso Denegado", isPresented: $showingAlert) {
            Button("Abrir Ajustes") {
                permissionManager.openAppSettings()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Por favor, habilita los permisos en Ajustes para usar esta funcionalidad.")
        }
        .onAppear {
            permissionManager.checkAllPermissions()
        }
    }
}

struct RealPermissionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let status: PermissionManager.PermissionStatus
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(statusColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(AppTheme.whiteSharp)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
            }
            
            Spacer()
            
            Button(action: action) {
                Text(statusText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack)
        .cornerRadius(12)
    }
    
    var statusText: String {
        switch status {
        case .notDetermined: return "Permitir"
        case .granted: return "Permitido"
        case .denied: return "Denegado"
        }
    }
    
    var statusColor: Color {
        switch status {
        case .granted: return .green
        case .denied: return .red
        case .notDetermined: return AppTheme.championBurgundy
        }
    }
}

#Preview {
    RealPermissionsView()
}
