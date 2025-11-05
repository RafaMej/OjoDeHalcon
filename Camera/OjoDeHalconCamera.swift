//
//  OjoDeHalconCamera.swift
//  OjoDeHalcon
//
//  Created by iOS Lab on 05/11/25.
//

//  Analyst/OjoDeHalconCamera.swift
//  (Based on your provided Model.swift, modified for Vision)

import AVFoundation
import CoreImage
import UIKit
import os.log
import CoreML
import Vision // Import Vision

class OjoDeHalconCamera: NSObject {
    private let captureSession = AVCaptureSession()
    private var isCaptureSessionConfigured = false
    private var deviceInput: AVCaptureDeviceInput?
    // private var photoOutput: AVCapturePhotoOutput? // Removed: Not needed for live detection
    private var videoOutput: AVCaptureVideoDataOutput?
    private var sessionQueue: DispatchQueue!
    
    // --- Vision/Core ML Properties ---
    private var visionRequests = [VNRequest]()
    private let labels: [Int: String] = [
        0: "ball",
        1: "goalkeeper",
        2: "player",
        3: "referee"
    ]
    
    // --- Preview Stream (from your code) ---
    private var addToPreviewStream: ((CIImage) -> Void)?
    var isPreviewPaused = false
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { ciImage in
                if !self.isPreviewPaused {
                    continuation.yield(ciImage)
                }
            }
        }
    }()
    
    // --- Detections Stream (NEW) ---
    private var addToDetectionsStream: (([Detection]) -> Void)?
    lazy var detectionsStream: AsyncStream<[Detection]> = {
        AsyncStream { continuation in
            addToDetectionsStream = { detections in
                continuation.yield(detections)
            }
        }
    }()

    
    // --- Camera Setup (from your code, simplified) ---
    
    private var allCaptureDevices: [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
    }
    private var backCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices.filter { $0.position == .back }
    }
    private var captureDevice: AVCaptureDevice? {
        didSet {
            guard let captureDevice = captureDevice else { return }
            logger.debug("Using capture device: \(captureDevice.localizedName)")
            sessionQueue.async {
                self.updateSessionForCaptureDevice(captureDevice)
            }
        }
    }

    var isRunning: Bool {
        captureSession.isRunning
    }

    override init() {
        super.init()
        initialize()
    }

    private func initialize() {
        sessionQueue = DispatchQueue(label: "session queue")
        captureDevice = backCaptureDevices.first ?? AVCaptureDevice.default(for: .video)
        
        // --- ADDED ---
        setupVision()
        
        // (Orientation notifications are good, keeping them)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateForDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // --- NEW: Vision Setup ---
    private func setupVision() {
        guard let modelURL = Bundle.main.url(forResource: "best", withExtension: "mlmodelc", subdirectory: "best.mlmodelpackage") else {
            logger.error("Error: Model file not found in bundle.")
            return
        }
        
        do {
            let compiledModel = try MLModel(contentsOf: modelURL)
            let visionModel = try VNCoreMLModel(for: compiledModel)
            
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            objectRecognition.imageCropAndScaleOption = .scaleFill
            
            self.visionRequests = [objectRecognition]
        } catch {
            logger.error("Error loading or initializing Vision model: \(error)")
        }
    }

    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
        var success = false
        self.captureSession.beginConfiguration()

        defer {
            self.captureSession.commitConfiguration()
            completionHandler(success)
        }

        guard
            let captureDevice = captureDevice,
            let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            logger.error("Failed to obtain video input.")
            return
        }
        
        // Use a high-quality session preset from your code if available, or fallback
        captureSession.sessionPreset = .hd1920x1080 // Using a high preset

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true

        guard captureSession.canAddInput(deviceInput) else {
            logger.error("Unable to add device input to capture session.")
            return
        }
        guard captureSession.canAddOutput(videoOutput) else {
            logger.error("Unable to add video output to capture session.")
            return
        }

        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)

        self.deviceInput = deviceInput
        self.videoOutput = videoOutput

        updateVideoOutputConnection()
        isCaptureSessionConfigured = true
        success = true
    }

    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            logger.debug("Camera access authorized.")
            return true
        case .notDetermined:
            logger.debug("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied, .restricted:
            logger.debug("Camera access denied or restricted.")
            return false
        @unknown default:
            return false
        }
    }

    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let error {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }

    private func updateSessionForCaptureDevice(_ captureDevice: AVCaptureDevice) {
        guard isCaptureSessionConfigured else { return }

        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        for input in captureSession.inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                captureSession.removeInput(deviceInput)
            }
        }

        if let deviceInput = deviceInputFor(device: captureDevice) {
            if !captureSession.inputs.contains(deviceInput), captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        updateVideoOutputConnection()
    }

    private func updateVideoOutputConnection() {
        if let videoOutput = videoOutput, let videoOutputConnection = videoOutput.connection(with: .video) {
            // Set orientation based on your helper function
            if videoOutputConnection.isVideoOrientationSupported,
               let videoOrientation = videoOrientationFor(deviceOrientation) {
                videoOutputConnection.videoOrientation = videoOrientation
            }
            
            // Mirroring (from your code)
            if videoOutputConnection.isVideoMirroringSupported {
                videoOutputConnection.isVideoMirrored = (captureDevice?.position == .front)
            }
        }
    }

    func start() async {
        let authorized = await checkAuthorization()
        guard authorized else {
            logger.error("Camera access was not authorized.")
            return
        }

        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                sessionQueue.async { [self] in
                    self.captureSession.startRunning()
                }
            }
            return
        }

        sessionQueue.async { [self] in
            self.configureCaptureSession { success in
                guard success else { return }
                self.captureSession.startRunning()
            }
        }
    }

    func stop() {
        guard isCaptureSessionConfigured else { return }

        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }

    // --- Orientation Helpers (from your code) ---
    private var deviceOrientation: UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        if orientation == UIDeviceOrientation.unknown {
            orientation = UIScreen.main.orientation
        }
        return orientation
    }

    @objc
    func updateForDeviceOrientation() {
        updateVideoOutputConnection()
    }

    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation? {
        switch deviceOrientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight // Flipped for capture
        case .landscapeRight: return .landscapeLeft // Flipped for capture
        default: return .portrait // Default
        }
    }
    
    // --- NEW: Vision Completion Handler ---
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let error = error {
            logger.error("Vision request failed: \(error.localizedDescription)")
            return
        }
        
        guard let observations = request.results as? [VNRecognizedObjectObservation] else {
            return
        }
        
        let newDetections = observations.compactMap { observation -> Detection? in
            guard let topLabel = observation.labels.first else { return nil }
            
            let labelName: String
            if let intID = Int(topLabel.identifier) {
                 labelName = self.labels[intID] ?? "unknown"
            } else {
                 labelName = topLabel.identifier
            }

            // Convert Vision's bottom-left origin (0-1) to SwiftUI's top-left origin (0-1)
            let convertedRect = CGRect(
                x: observation.boundingBox.origin.x,
                y: 1 - observation.boundingBox.origin.y - observation.boundingBox.height,
                width: observation.boundingBox.width,
                height: observation.boundingBox.height
            )

            return Detection(
                boundingBox: CGRect(),
                normalizedBox: convertedRect,
                label: Detection.DetectionLabel(rawValue: labelName) ?? .player,
                confidence: topLabel.confidence,
                timestamp: Date()
            )
        }
        
        // Publish detections to the new stream
        addToDetectionsStream?(newDetections)
    }
}

// --- Delegate Extension (MODIFIED) ---
extension OjoDeHalconCamera: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }

        // --- 1. Feed the Preview Stream (from your code) ---
        addToPreviewStream?(CIImage(cvPixelBuffer: pixelBuffer))
        
        // --- 2. Feed the Vision Request (NEW) ---
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform(self.visionRequests)
        } catch {
            logger.error("Failed to perform Vision request: \(error)")
        }
    }
}

// --- Helper extensions (from your code) ---
fileprivate extension UIScreen {
    var orientation: UIDeviceOrientation {
        let point = coordinateSpace.convert(CGPoint.zero, to: fixedCoordinateSpace)
        if point == CGPoint.zero {
            return .portrait
        } else if point.x != 0 && point.y != 0 {
            return .portraitUpsideDown
        } else if point.x == 0 && point.y != 0 {
            return .landscapeRight
        } else if point.x != 0 && point.y == 0 {
            return .landscapeLeft
        } else {
            return .unknown
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.proyectoSTEM.ojodehalcon", category: "OjoDeHalconCamera")
