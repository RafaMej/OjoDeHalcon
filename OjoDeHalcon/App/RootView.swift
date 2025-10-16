// En: OjoDeHalcon/App/RootView.swift

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        SwiftUI.Group {
            if !appState.isOnboardingCompleted {
                OnboardingView()
            } else if !appState.hasRequiredPermissions {
             
                RealPermissionsView()
            } else if !appState.isAuthenticated {
                AuthenticationView()
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState()) 
}
