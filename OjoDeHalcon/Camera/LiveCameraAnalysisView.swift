//
//  LiveCameraAnalysisView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 31/10/25.
//

import SwiftUI

struct LiveCameraAnalysisView: View {
    @StateObject private var cameraModel = CameraDataModel()
    @Binding var isPresented: Bool
    @State private var showSettings = false
    @State private var showGrid = true
    @State private var currentMinute = 0
    @State private var matchTimer: Timer?
    
    var body: some View {
        ZStack {
            // Camera Viewfinder
            CameraViewfinderView(
                image: $cameraModel.viewfinderImage,
                detections: cameraModel.currentDetections
            )
            .ignoresSafeArea()
            
            VStack {
                // Top Controls
                topControlsBar()
                
                Spacer()
                
                // AI Insights Panel (if analyzing)
                if cameraModel.isAnalyzing {
                    aiInsightsPanel()
                }
                
                // Bottom Controls
                bottomControlsBar()
            }
        }
        .statusBar(hidden: true)
        .task {
            await cameraModel.camera.start()
        }
        .onAppear {
            startMatchTimer()
        }
        .onDisappear {
            stopMatchTimer()
            Task {
                cameraModel.camera.stop()
            }
        }
        .sheet(isPresented: $showSettings) {
            CameraSettingsView(showGrid: $showGrid)
        }
    }
    
    // MARK: - Top Controls
    
    private func topControlsBar() -> some View {
        HStack {
            // Close Button
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding(12)
                    .background(AppTheme.tacticalBlack.opacity(0.7))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Match Time
            if cameraModel.isAnalyzing {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                    
                    Text("\(currentMinute)'")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.whiteSharp)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppTheme.tacticalBlack.opacity(0.7))
                .cornerRadius(20)
            }
            
            Spacer()
            
            // Grid Toggle
            Button(action: { showGrid.toggle() }) {
                Image(systemName: showGrid ? "grid" : "grid.circle")
                    .font(.title3)
                    .foregroundColor(showGrid ? AppTheme.aiCyan : AppTheme.whiteSharp)
                    .padding(12)
                    .background(AppTheme.tacticalBlack.opacity(0.7))
                    .clipShape(Circle())
            }
            
            // Settings Button
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding(12)
                    .background(AppTheme.tacticalBlack.opacity(0.7))
                    .clipShape(Circle())
            }
        }
        .padding()
    }
    
    // MARK: - AI Insights Panel
    
    private func aiInsightsPanel() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(AppTheme.aiCyan)
                
                Text("Análisis IA")
                    .font(.headline)
                    .foregroundColor(AppTheme.aiCyan)
                
                Spacer()
                
                Text("\(cameraModel.currentDetections.count) objetos")
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.7))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppTheme.tacticalBlack.opacity(0.5))
                    .cornerRadius(8)
            }
            
            // Insights
            if cameraModel.tacticalInsights.isEmpty {
                Text("Analizando formaciones y movimientos...")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.7))
            } else {
                ForEach(cameraModel.tacticalInsights.prefix(2), id: \.self) { insight in
                    HStack {
                        Circle()
                            .fill(AppTheme.gloryGold)
                            .frame(width: 6, height: 6)
                        
                        Text(insight)
                            .font(.subheadline)
                            .foregroundColor(AppTheme.whiteSharp)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.tacticalBlack.opacity(0.85))
        )
        .padding(.horizontal)
        .padding(.bottom, 120)
    }
    
    // MARK: - Bottom Controls
    
    private func bottomControlsBar() -> some View {
        HStack(spacing: 40) {
            // Flash Toggle
            Button(action: {
                // Toggle flash
            }) {
                Image(systemName: "bolt.slash.fill")
                    .font(.title2)
                    .foregroundColor(AppTheme.whiteSharp)
                    .frame(width: 50, height: 50)
            }
            
            // Analysis Toggle (Main Button)
            Button(action: {
                if cameraModel.isAnalyzing {
                    cameraModel.stopAnalysis()
                } else {
                    cameraModel.startAnalysis()
                }
            }) {
                ZStack {
                    Circle()
                        .stroke(cameraModel.isAnalyzing ? AppTheme.championBurgundy : AppTheme.gloryGold, lineWidth: 4)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .fill(cameraModel.isAnalyzing ? AppTheme.championBurgundy : AppTheme.gloryGold)
                        .frame(width: 58, height: 58)
                    
                    Image(systemName: cameraModel.isAnalyzing ? "stop.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(AppTheme.tacticalBlack)
                }
            }
            
            // Camera Switch
            Button(action: {
                cameraModel.camera.switchCaptureDevice()
            }) {
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                    .font(.title2)
                    .foregroundColor(AppTheme.whiteSharp)
                    .frame(width: 50, height: 50)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(AppTheme.tacticalBlack.opacity(0.9))
        )
    }
    
    // MARK: - Timer Functions
    
    private func startMatchTimer() {
        matchTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            if cameraModel.isAnalyzing {
                currentMinute += 1
            }
        }
    }
    
    private func stopMatchTimer() {
        matchTimer?.invalidate()
        matchTimer = nil
    }
}

// MARK: - Camera Settings View

struct CameraSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showGrid: Bool
    @State private var detectionSensitivity: Double = 0.5
    
    var body: some View {
        NavigationView {
            Form {
                Section("Visualización") {
                    Toggle("Mostrar cuadrícula táctica", isOn: $showGrid)
                    Toggle("Mostrar trayectorias", isOn: .constant(true))
                    Toggle("Mostrar confianza de detección", isOn: .constant(true))
                }
                
                Section("Análisis IA") {
                    VStack(alignment: .leading) {
                        Text("Sensibilidad de detección")
                            .font(.subheadline)
                        
                        Slider(value: $detectionSensitivity, in: 0...1)
                        
                        Text("Valor: \(Int(detectionSensitivity * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Rendimiento") {
                    Toggle("Modo de bajo consumo", isOn: .constant(false))
                    Toggle("Reducir resolución", isOn: .constant(false))
                }
            }
            .navigationTitle("Configuración")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LiveCameraAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        LiveCameraAnalysisView(isPresented: .constant(true))
    }
}
