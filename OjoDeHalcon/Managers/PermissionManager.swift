//
//  PermissionManager.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 14/10/25.
//

import AVFoundation
import UserNotifications

class PermissionManager: ObservableObject {
    static let shared = PermissionManager()
    
    @Published var cameraStatus: PermissionStatus = .notDetermined
    @Published var notificationStatus: PermissionStatus = .notDetermined
    
    enum PermissionStatus {
        case notDetermined
        case granted
        case denied
    }
    
    private init() {
        checkAllPermissions()
    }
    
    func checkAllPermissions() {
        checkCameraPermission()
        checkNotificationPermission()
    }
    
    // MARK: - Camera Permission
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraStatus = .granted
        case .denied, .restricted:
            cameraStatus = .denied
        case .notDetermined:
            cameraStatus = .notDetermined
        @unknown default:
            cameraStatus = .notDetermined
        }
    }
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.cameraStatus = granted ? .granted : .denied
                completion(granted)
                
                FirebaseManager.shared.logEvent("permission_requested", parameters: [
                    "type": "camera",
                    "result": granted ? "granted" : "denied"
                ])
            }
        }
    }
    
    // MARK: - Notification Permission
    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    self?.notificationStatus = .granted
                case .denied:
                    self?.notificationStatus = .denied
                case .notDetermined:
                    self?.notificationStatus = .notDetermined
                @unknown default:
                    self?.notificationStatus = .notDetermined
                }
            }
        }
    }
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.notificationStatus = granted ? .granted : .denied
                completion(granted)
                
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
                FirebaseManager.shared.logEvent("permission_requested", parameters: [
                    "type": "notification",
                    "result": granted ? "granted" : "denied"
                ])
            }
        }
    }
    
    // MARK: - Open Settings
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
