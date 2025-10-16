// OjoDeHalcon/ThemeConfiguration.swift

import SwiftUI

struct AppTheme {
    static let championBurgundy = Color(hex: "8D1B3D")
    static let tacticalBlack = Color(hex: "121212")
    static let whiteSharp = Color(hex: "FFFFFF")
    static let gloryGold = Color(hex: "FFD700")
    static let aiCyan = Color(hex: "00FFFF")
}

struct AppFonts {
    static func titleStyle() -> some ViewModifier {
        return TitleModifier()
    }
}

private struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(AppTheme.whiteSharp)
    }
}

// --- ESTILOS DE BOTÓN ---
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .foregroundColor(AppTheme.tacticalBlack)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.gloryGold)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

enum AppColors {
    // Principal (puedes cambiar a Color("AppTint") más adelante)
    static let accent = Color.accentColor

    // Fondos semánticos
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let bubbleUser = accent.opacity(0.12)
    static let bubbleAssistant = secondaryBackground

    // Separadores / líneas
    static let separator = Color(.separator)
}

struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.tacticalBlack.opacity(0.4))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.whiteSharp.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardViewModifier())
    }
}
struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .foregroundColor(AppTheme.whiteSharp) // Texto blanco para contraste
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.championBurgundy) // Nuestro color rojo temático
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
