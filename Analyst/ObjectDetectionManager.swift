//
//  ObjectDetectionManager.swift
//  OjoDeHalcon
//
//  Created by iOS Lab on 05/11/25.
//

import Foundation
import AVFoundation
import Vision
import UIKit
import Combine

// This class must inherit from NSObject to be the delegate for AVCaptureVideoDataOutput
class ObjectDetectionCameraManager: NSObject, ObservableObject {
    
    // Published properties to update the UI
    @Published var detections: [Detection] = []
    
    // Camera session
    var captureSession = AVCaptureSession()
    private var videoOutput = AVCaptureVideoDataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // Vision
    private var visionRequests = [VNRequest]()
    // Define the labels based on your model's output
    private let labels: [Int: String] = [
        0: "ball",
        1: "goalkeeper",
        2: "player",
        3: "referee"
    ]
    
    override init() {
        super.init()
        setupVision()
        setupCamera()
    }
    
    // MARK: - Vision (Core ML) Setup
    
    private func setupVision() {
        guard let modelURL = Bundle.main.url(forResource: "best", withExtension: "mlmodelc", subdirectory: "best.mlmodelpackage") else {
            print("Error: Model file not found in bundle.")
            return
        }
        
        do {
            let compiledModel = try MLModel(contentsOf: modelURL)
            let visionModel = try VNCoreMLModel(for: compiledModel)
            
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            // Use .scaleFill to match your model's [960, 960] input size
            objectRecognition.imageCropAndScaleOption = .scaleFill
            
            self.visionRequests = [objectRecognition]
        } catch {
            print("Error loading or initializing Vision model: \(error)")
        }
    }
    
    // MARK: - Camera (AVFoundation) Setup
    
    private func setupCamera() {
        // Use high-quality preset
        captureSession.sessionPreset = .hd1920x1080
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Error: Back camera not available.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            // Set up video output
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            // Add input and output to the session
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            // Improve performance by setting orientation
            if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        } catch {
            print("Error setting up camera input: \(error)")
        }
    }
    
    // MARK: - Public Controls
    
    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Vision Request Completion
    
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let error = error {
            print("Vision request failed: \(error.localizedDescription)")
            return
        }
        
        guard let observations = request.results as? [VNRecognizedObjectObservation] else {
            return
        }
        
        // Convert observations to our custom Detection struct
        let newDetections = observations.compactMap { observation -> Detection? in
            // Get the top label (most confident)
            guard let topLabel = observation.labels.first else { return nil }
            
            // Get label name from our dictionary. Note: VNCoreMLRequest might return the class name directly.
            // If `topLabel.identifier` is already "player", "ball", etc., you can skip the dictionary.
            // Let's assume the identifier is an Int you need to map.
            let labelName: String
            if let intID = Int(topLabel.identifier) {
                 labelName = self.labels[intID] ?? "unknown"
            } else {
                 // Fallback if the identifier is already a string like "player"
                 labelName = topLabel.identifier
            }

            // **Critical Coordinate Conversion**
            // Vision's boundingBox (0-1) has a BOTTOM-left origin.
            // SwiftUI's coordinate system (0-1) has a TOP-left origin.
            // We must flip the Y-coordinate.
            let convertedRect = CGRect(
                x: observation.boundingBox.origin.x,
                y: 1 - observation.boundingBox.origin.y - observation.boundingBox.height, // Flip Y-origin
                width: observation.boundingBox.width,
                height: observation.boundingBox.height
            )

            return Detection(
                boundingBox: CGRect(), // We will use normalizedBox, so this can be empty
                normalizedBox: convertedRect,
                label: Detection.DetectionLabel(rawValue: labelName) ?? .player, // Use your DetectionLabel enum
                confidence: topLabel.confidence,
                timestamp: Date()
            )
        }
        
        // Publish detections on the main thread for the UI
        DispatchQueue.main.async {
            self.detections = newDetections
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ObjectDetectionCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // Create a handler for this one frame
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            // Perform the vision requests
            try handler.perform(self.visionRequests)
        } catch {
            print("Failed to perform Vision request: \(error)")
        }
    }
}
