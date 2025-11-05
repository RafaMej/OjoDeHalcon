//
//  OjodeHalconCameraModel.swift
//  OjoDeHalcon
//
//  Created by iOS Lab on 05/11/25.
//


import AVFoundation
import SwiftUI
import os.log

final class OjoDeHalconCameraModel: ObservableObject {
    let camera = OjoDeHalconCamera()
    
    @Published var viewfinderImage: Image?
    @Published var detections: [Detection] = [] // NEW

    init() {
        Task {
            await handleCameraPreviews()
        }
        Task {
            await handleCameraDetections() // NEW
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image } // Use your CIImage extension

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }
    
    // NEW: Subscribes to the detections stream from the camera
    func handleCameraDetections() async {
        for await detections in camera.detectionsStream {
            Task { @MainActor in
                self.detections = detections
            }
        }
    }
}

// Helper extension from your code
fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
