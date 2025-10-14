//
//  AppState.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

class AppState: ObservableObject {
    @Published var isOnboardingCompleted: Bool = UserDefaults.standard.bool(forKey: "onboardingCompleted")
    @Published var hasRequiredPermissions: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
    }
}
