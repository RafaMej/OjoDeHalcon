//
//  CameraViewfinderView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 31/10/25.
//

import SwiftUI

struct CameraViewfinderView: View {
    @Binding var image: Image?
    var detections: [Detection] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Camera Preview
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                
                // Detection Overlays
                ForEach(detections) { detection in
                    DetectionBoxView(detection: detection, frameSize: geometry.size)
                }
                
                // Tactical Grid Overlay (Optional)
                TacticalGridOverlay()
                    .stroke(AppTheme.aiCyan.opacity(0.3), lineWidth: 1)
            }
        }
    }
}

// MARK: - Detection Box View

struct DetectionBoxView: View {
    let detection: Detection
    let frameSize: CGSize
    
    var body: some View {
        let box = detection.normalizedBox
        let x = box.origin.x * frameSize.width
        let y = box.origin.y * frameSize.height
        let width = box.size.width * frameSize.width
        let height = box.size.height * frameSize.height
        
        ZStack(alignment: .topLeading) {
            Rectangle()
                .stroke(colorForDetection(), lineWidth: 2)
                .frame(width: width, height: height)
                .position(x: x + width/2, y: y + height/2)
            
            // Label
            Text(detection.label.rawValue.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(4)
                .background(colorForDetection())
                .cornerRadius(4)
                .position(x: x + 30, y: y - 10)
        }
    }
    
    private func colorForDetection() -> Color {
        switch detection.label {
        case .player:
            switch detection.team {
            case .home: return AppTheme.championBurgundy
            case .away: return AppTheme.gloryGold
            case .neutral, .none: return .white
            }
        case .ball: return AppTheme.aiCyan
        case .referee: return .yellow
        case .goalpost: return .orange
        }
    }
}

// MARK: - Tactical Grid Overlay

struct TacticalGridOverlay: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Vertical lines
        let verticalSpacing = rect.width / 3
        for i in 1..<3 {
            let x = CGFloat(i) * verticalSpacing
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        // Horizontal lines
        let horizontalSpacing = rect.height / 3
        for i in 1..<3 {
            let y = CGFloat(i) * horizontalSpacing
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        // Center circle
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        let radius = min(rect.width, rect.height) / 8
        path.addEllipse(in: CGRect(
            x: centerX - radius,
            y: centerY - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        return path
    }
}

struct CameraViewfinderView_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewfinderView(
            image: .constant(Image(systemName: "camera")),
            detections: []
        )
    }
}
