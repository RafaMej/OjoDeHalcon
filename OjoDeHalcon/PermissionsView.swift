
//
//  PermissionsView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//
import SwiftUI

struct PermissionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var cameraPermission: PermissionStatus = .notDetermined
    @State private var notificationPermission: PermissionStatus = .notDetermined
    
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
                    PermissionRow(
                        icon: "camera.fill",
                        title: "Cámara",
                        status: cameraPermission,
                        action: requestCameraPermission
                    )
                    
                    PermissionRow(
                        icon: "bell.fill",
                        title: "Notificaciones",
                        status: notificationPermission,
                        action: requestNotificationPermission
                    )
                }
                .padding()
                .background(AppTheme.tacticalBlack.opacity(0.3))
                .cornerRadius(16)
                
                if cameraPermission == .denied {
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
                    if cameraPermission == .granted {
                        appState.hasRequiredPermissions = true
                    } else {
                        appState.hasRequiredPermissions = true
                    }
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
        .onAppear {
            checkPermissions()
        }
    }
    
    func checkPermissions() {
        // Check camera permission
        // Implementation needed
    }
    
    func requestCameraPermission() {
        // Request camera permission
        // Implementation needed
    }
    
    func requestNotificationPermission() {
        // Request notification permission
        // Implementation needed
    }
}

enum PermissionStatus {
    case notDetermined, granted, denied
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let status: PermissionStatus
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.gloryGold)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(AppTheme.whiteSharp)
            
            Spacer()
            
            Button(action: action) {
                Text(statusText)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor)
                    .foregroundColor(AppTheme.whiteSharp)
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
