// OjoDeHalcon/Views/OnboardingView.swift

import SwiftUI


struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let imageName: String // ¡Nuevo!
    let imageDescription: String // ¡Nuevo!
}

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    // Actualizamos el array de páginas con los nuevos datos
    let pages = [
        OnboardingPage(
                    icon: "chart.bar.xaxis",
                    title: "CONOCE A TU ANALISTA",
                    description: "Explica el partido con datos y estadísticas en tiempo real",
                    color: AppTheme.gloryGold,
                    imageName: "onboarding_analyst", // Debes añadir esta imagen
                    imageDescription: "Tu analista IA personal que observa, analiza y te ofrece insights que no verías a simple vista."
                ),
        OnboardingPage(
            icon: "camera.fill",
            title: "MIRA CON OJOS DE IA",
            description: "Analiza cada jugada en tiempo real",
            color: AppTheme.gloryGold,
            imageName: "onboarding_ai_analysis",
            imageDescription: "Nuestra IA identifica jugadores, sigue el balón y te da una nueva perspectiva del partido."
        ),
        OnboardingPage(
            icon: "target",
            title: "ENTIENDE LA TÁCTICA",
            description: "Visualiza formaciones y estrategias",
            color: AppTheme.gloryGold,
            imageName: "onboarding_tactics", // Debes añadir esta imagen
            imageDescription: "Visualiza formaciones, movimientos y zonas de influencia como nunca antes. La estrategia del entrenador, en la palma de tu mano"
        ),
        OnboardingPage(
            icon: "globe",
            title: "SIN BARRERAS DE IDIOMA",
            description: "Traducción en vivo de comentarios y noticias",
            color: AppTheme.gloryGold,
            imageName: "onboarding_translation", // Debes añadir esta imagen
            imageDescription: "Sigue la conversación global con traducciones instantáneas de las transmisiones y redes sociales más importantes."
        )
    ]
    
    var body: some View {
        ZStack {
            // Usamos un fondo oscuro y consistente
            AppTheme.tacticalBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- BARRA SUPERIOR PERSONALIZADA ---
                HStack {
                    // Indicadores de progreso
                    HStack(spacing: 4) {
                        ForEach(pages.indices, id: \.self) { index in
                            Capsule()
                                .fill(index <= currentPage ? AppTheme.gloryGold : .gray.opacity(0.5))
                                .frame(height: 4)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    
                    Spacer()
                    
                    Button("Saltar") {
                        appState.completeOnboarding()
                    }
                    .foregroundStyle(AppTheme.whiteSharp.opacity(0.8))
                }
                .padding()

                // --- CONTENIDO DE LA PÁGINA ---
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // Ocultamos los puntos por defecto

                // --- NAVEGACIÓN INFERIOR PERSONALIZADA ---
                HStack {
                    // Botón Anterior (solo visible después de la primera página)
                    if currentPage > 0 {
                        Button("Anterior") {
                            withAnimation(.spring()) {
                                currentPage -= 1
                            }
                        }
                        .foregroundStyle(AppTheme.whiteSharp)
                    }
                    
                    Spacer()
                    
                    // Botón Siguiente / Continuar
                    Button(action: handleNextButton) {
                        Text(currentPage == pages.count - 1 ? "Comenzar" : "Siguiente")
                    }
                    // Usamos nuestro estilo de botón primario para consistencia
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(width: 150)
                }
                .padding(32)
            }
        }
    }
    
    func handleNextButton() {
        if currentPage == pages.count - 1 {
            appState.completeOnboarding()
        } else {
            withAnimation(.spring()) {
                currentPage += 1
            }
        }
    }
}


// --- 2. VISTA DE PÁGINA RECONSTRUIDA ---
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            // Icono y Títulos
            VStack {
                Image(systemName: page.icon)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(page.color)
                    .padding(.bottom, 16)
                
                Text(page.title)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(AppTheme.whiteSharp)
                
                Text(page.description)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.whiteSharp.opacity(0.7))
            }
            .multilineTextAlignment(.center)


            VStack {
                Image(page.imageName) // La nueva imagen
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.3), radius: 10)
                
                Text(page.imageDescription)
                    .font(.callout)
                    .foregroundStyle(AppTheme.whiteSharp)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    // Es importante añadir el environmentObject al preview
    OnboardingView()
        .environmentObject(AppState())
}
