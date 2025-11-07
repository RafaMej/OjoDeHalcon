//
//  CameraDataModel.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 31/10/25.
//

import AVFoundation
import SwiftUI
import os.log
import CoreML

final class CameraDataModel: ObservableObject {
    let camera = Camera()
    
    @Published var viewfinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published var lastCapturedImage: Image?
    @Published var isAnalyzing = false
    @Published var currentDetections: [Detection] = []
    
    // MARK: - Analysis State
    @Published var matchInfo: MatchAnalysisInfo?
    @Published var tacticalInsights: [String] = []
    
    var isPhotosLoaded = false
    
    init() {
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    // MARK: - Camera Stream Handlers
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
                
                // Si está analizando, procesar el frame
                if isAnalyzing {
                    performFrameAnalysis(image: image)
                }
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream.compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                if let uiImage = UIImage(data: photoData.imageData) {
                    lastCapturedImage = Image(uiImage: uiImage.fixOrientation())
                }
                viewfinderImage = photoData.thumbnailImage
            }
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        
        guard let previewCGImage = photo.previewCGImageRepresentation(),
              let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }
    
    // MARK: - AI Analysis Methods
    
    func startAnalysis() {
        isAnalyzing = true
        logger.info("🔍 Análisis IA iniciado")
    }
    
    func stopAnalysis() {
        isAnalyzing = false
        currentDetections.removeAll()
        logger.info("⏹️ Análisis IA detenido")
    }
    
    private func performFrameAnalysis(image: Image?) {
        // TODO: Implementar detección con CoreML
        // Aquí irá la lógica de detección de jugadores, balón, etc.
        
        // Simulación de detección (reemplazar con CoreML real)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.generateMockDetection()
        }
    }
    
    private func generateMockDetection() {
        // Simulación temporal - remover cuando tengas el modelo CoreML
        let mockDetection = Detection(
            boundingBox: CGRect(x: 100, y: 100, width: 50, height: 50),
            normalizedBox: CGRect(x: 0.3, y: 0.3, width: 0.1, height: 0.1),
            label: .player,
            confidence: 0.85,
            trackingID: 1,
            team: .home,
            timestamp: Date()
        )
        
        if currentDetections.count < 22 { // Máximo 22 jugadores
            currentDetections.append(mockDetection)
        }
    }
}

// MARK: - Supporting Types

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

struct MatchAnalysisInfo {
    var homeTeam: String
    var awayTeam: String
    var currentMinute: Int
    var formation: String
}

// MARK: - Extensions (solo las que NO están en CameraModel.swift)

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {
    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}

// NOTA: UIImage.fixOrientation() ya está definida en CameraModel.swift
// No la redefinimos aquí para evitar conflictos

fileprivate let logger = Logger(subsystem: "com.ojohalcon.app", category: "CameraDataModel")
