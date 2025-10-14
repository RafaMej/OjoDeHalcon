//
//  RootView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if !appState.isOnboardingCompleted {
                OnboardingView()
            } else if !appState.hasRequiredPermissions {
                PermissionsView()
            } else if !appState.isAuthenticated {
                AuthenticationView()
            } else {
                MainTabView()
            }
        }
    }
}
