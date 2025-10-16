//
//  LoadingView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 14/10/25.
//
import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            AppTheme.tacticalBlack.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "sportscourt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(AppTheme.gloryGold)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 5).repeatForever(autoreverses: false), value: isAnimating)
                
                Text("Cargando...")
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView()
}
