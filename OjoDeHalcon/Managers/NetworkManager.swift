//
//  NetworkManager.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 14/10/25.
//
import SwiftUI

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.ojodehalcon.com/v1"
    private let session: URLSession
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
        case serverError(Int)
    }
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let parameters = parameters, method != "GET" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
    
    private func getAuthToken() -> String? {
        // Get Firebase Auth token
        return Auth.auth().currentUser?.uid
    }
}

// MARK: - Extensions

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - Custom Modifiers

struct GlassmorphismModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    func glassmorphism() -> some View {
        modifier(GlassmorphismModifier())
    }
}
