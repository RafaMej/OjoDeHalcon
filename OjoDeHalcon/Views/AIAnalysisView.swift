//
//  AIAnalysisView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//
//
//  AIAnalysisView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 13/10/25.
//
import SwiftUI


struct AIAnalysisView: View {
    @State private var isAnalyzing = false
    
    var body: some View {
        ZStack {
            AppTheme.tacticalBlack.ignoresSafeArea()
            
            VStack {
                if !isAnalyzing {
                    // ... (Your existing "Start Analysis" view)
                    VStack(spacing: 32) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(AppTheme.championBurgundy.opacity(0.3))
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(AppTheme.whiteSharp)
                        }
                        
                        VStack(spacing: 16) {
                            Text("Análisis IA en Vivo")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.whiteSharp)
                            
                            Text("Apunta la cámara al partido para comenzar el análisis táctico en tiempo real")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.whiteSharp.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        
                        Spacer()
                        
                        Button(action: { isAnalyzing = true }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Iniciar Análisis")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(AppTheme.tacticalBlack)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.gloryGold)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                    }
                } else {
                    // Use the new LiveAnalysisCameraView
                    LiveAnalysisCameraView(isAnalyzing: $isAnalyzing)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// --- MODIFIED LiveAnalysisView ---
struct LiveAnalysisCameraView: View {
    @Binding var isAnalyzing: Bool
    
    // 1. Use the new Camera Model as the single source of truth
    @StateObject private var dataModel = OjoDeHalconCameraModel()
    
    var body: some View {
        ZStack {
            // 2. Display the viewfinder image from the DataModel
            if let image = dataModel.viewfinderImage {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
            }
            
            // 3. Draw Bounding Boxes from the DataModel
            DetectionOverlayView(detections: dataModel.detections)
            
            // 4. Your existing UI, on top of the camera feed
            VStack {
                HStack {
                    HStack {
                        Circle().fill(Color.red).frame(width: 8, height: 8)
                        Text("EN VIVO").font(.caption).fontWeight(.bold)
                    }
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(.black.opacity(0.5)).cornerRadius(16)
                    
                    Text("90+3'").foregroundColor(AppTheme.whiteSharp).fontWeight(.bold)
                        .padding(8).background(.black.opacity(0.5)).cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "square.grid.2x2").foregroundColor(AppTheme.whiteSharp)
                            .padding(10).background(.black.opacity(0.5)).clipShape(Circle())
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "gearshape").foregroundColor(AppTheme.whiteSharp)
                            .padding(10).background(.black.opacity(0.5)).clipShape(Circle())
                    }
                }
                .padding()
                .padding(.top, 30) // Add padding for safe area
                
                Spacer()
                
                // (Footer is removed as per your previous request)
            }
        }
        // 5. Start/Stop the session when the view appears/disappears
        .onAppear {
            Task { await dataModel.camera.start() }
        }
        .onDisappear {
            dataModel.camera.stop()
        }
    }
}

// 6. The Bounding Box Overlay View (Unchanged from previous step)
struct DetectionOverlayView: View {
    let detections: [Detection]
    
    var body: some View {
        GeometryReader { geo in
            ForEach(detections) { detection in
                let rect = detection.normalizedBox
                let frame = CGRect(
                    x: rect.origin.x * geo.size.width,
                    y: rect.origin.y * geo.size.height,
                    width: rect.width * geo.size.width,
                    height: rect.height * geo.size.height
                )
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .stroke(Color.yellow, lineWidth: 2)
                    
                    Text("\(detection.label.rawValue) \(String(format: "%.0f%%", detection.confidence * 100))")
                        .font(.caption)
                        .padding(4)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .offset(y: -20)
                }
                .frame(width: frame.width, height: frame.height)
                .position(x: frame.minX + frame.width / 2, y: frame.minY + frame.height / 2)
            }
        }
    }
}
/*
struct AIAnalysisView: View {
    @State private var isAnalyzing = false
    
    var body: some View {
        ZStack {
            AppTheme.tacticalBlack.ignoresSafeArea()
            
            VStack {
                if !isAnalyzing {
                    VStack(spacing: 32) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(AppTheme.championBurgundy.opacity(0.3))
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(AppTheme.whiteSharp)
                        }
                        
                        VStack(spacing: 16) {
                            Text("Análisis IA en Vivo")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.whiteSharp)
                            
                            Text("Apunta la cámara al partido para comenzar el análisis táctico en tiempo real")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.whiteSharp.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        
                        Spacer()
                        
                        Button(action: { isAnalyzing = true }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Iniciar Análisis")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(AppTheme.tacticalBlack)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.gloryGold)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                    }
                } else {
                    LiveAnalysisView(isAnalyzing: $isAnalyzing)
                }
            }
        }
    }
}

struct LiveAnalysisView: View {
    @Binding var isAnalyzing: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                // Match Score Header
                HStack {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("EN VIVO")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(16)
                    
                    Text("90+3'")
                        .foregroundColor(AppTheme.whiteSharp)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(AppTheme.whiteSharp)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .foregroundColor(AppTheme.whiteSharp)
                    }
                }
                .padding()
                
                // Score Display
                HStack {
                    VStack {
                        Text("Argentina")
                            .foregroundColor(AppTheme.whiteSharp)
                        Text("2")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.championBurgundy)
                    }
                    
                    Text("VS")
                        .foregroundColor(AppTheme.whiteSharp.opacity(0.5))
                    
                    VStack {
                        Text("Francia")
                            .foregroundColor(AppTheme.whiteSharp)
                        Text("1")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.gloryGold)
                    }
                }
                .padding()
                .background(AppTheme.tacticalBlack.opacity(0.8))
                .cornerRadius(16)
                
                Spacer()
                
                // AI Insight Card
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(AppTheme.aiCyan)
                    Text("Análisis IA")
                        .foregroundColor(AppTheme.aiCyan)
                        .fontWeight(.bold)
                    Text("71:30")
                        .foregroundColor(AppTheme.whiteSharp)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.tacticalBlack)
                        .cornerRadius(8)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.tacticalBlack.opacity(0.9))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Francia reorganizando la defensa tras pérdida de balón")
                        .foregroundColor(AppTheme.whiteSharp)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.tacticalBlack.opacity(0.9))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            
            VStack {
                Spacer()
                Button(action: { isAnalyzing = false }) {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("Detener Análisis")
                    }
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding()
                    .background(AppTheme.championBurgundy)
                    .cornerRadius(12)
                }
                .padding(.bottom, 32)
            }
        }
    }
}
    */
#Preview {
    AIAnalysisView()
}
