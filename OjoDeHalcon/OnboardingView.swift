//
//  OnboardingView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            icon: "camera.fill",
            title: "MIRA CON OJOS DE IA",
            description: "Analiza cada jugada en tiempo real",
            color: AppTheme.aiCyan
        ),
        OnboardingPage(
            icon: "target",
            title: "ENTIENDE LA TÁCTICA",
            description: "Visualiza formaciones y estrategias",
            color: AppTheme.gloryGold
        ),
        OnboardingPage(
            icon: "globe",
            title: "SIN BARRERAS DE IDIOMA",
            description: "Traducción en vivo de comentarios y noticias",
            color: AppTheme.championBurgundy
        )
    ]
    
    var body: some View {
        ZStack {
            AppTheme.championBurgundy.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Saltar") {
                        appState.completeOnboarding()
                    }
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding()
                }
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                if currentPage == pages.count - 1 {
                    Button(action: { appState.completeOnboarding() }) {
                        Text("Continuar")
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.tacticalBlack)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.gloryGold)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 200, height: 200)
                
                Image(systemName: page.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(page.color)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.whiteSharp)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
        }
    }
}
