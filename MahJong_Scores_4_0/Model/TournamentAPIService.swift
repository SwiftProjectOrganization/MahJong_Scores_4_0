//
//  TournamentAPIService.swift
//  MahJong_Scores_4_0
//
//  Service for interacting with the MahJong Scores API
//
// NOTE: This is a placeholder implementation until OpenAPI packages are added
// See API/README.md for setup instructions

import Foundation
import Observation

@Observable
class TournamentAPIService {
    private let serverURL: URL
    
    var isConnected: Bool = false
    var lastError: String?
    
    init(serverURL: String = "http://Rob-Travel-M5.local:8080") {
        self.serverURL = URL(string: serverURL)!
    }
    
    // MARK: - API Methods
    
    /// Upload a tournament to the server
    func uploadTournament(_ tournament: TournamentDTO) async throws -> TournamentDTO {
        // Placeholder implementation until OpenAPI packages are configured
        var request = URLRequest(url: serverURL.appendingPathComponent("/tournaments"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(tournament)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        guard httpResponse.statusCode == 201 else {
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(TournamentDTO.self, from: data)
        isConnected = true
        return result
    }
    
    /// List all tournaments from the server
    func listTournaments() async throws -> [TournamentDTO] {
        let request = URLRequest(url: serverURL.appendingPathComponent("/tournaments"))
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode([TournamentDTO].self, from: data)
        isConnected = true
        return result
    }
    
    /// Get a specific tournament by ID
    func getTournament(id: UUID) async throws -> TournamentDTO {
        let url = serverURL.appendingPathComponent("/tournaments/\(id.uuidString)")
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        if httpResponse.statusCode == 404 {
            throw APIError.notFound
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(TournamentDTO.self, from: data)
        isConnected = true
        return result
    }
    
    /// Update a tournament on the server
    func updateTournament(id: UUID, tournament: TournamentDTO) async throws -> TournamentDTO {
        let url = serverURL.appendingPathComponent("/tournaments/\(id.uuidString)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(tournament)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        if httpResponse.statusCode == 404 {
            throw APIError.notFound
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(TournamentDTO.self, from: data)
        isConnected = true
        return result
    }
    
    /// Delete a tournament from the server
    func deleteTournament(id: UUID) async throws {
        let url = serverURL.appendingPathComponent("/tournaments/\(id.uuidString)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        if httpResponse.statusCode == 404 {
            throw APIError.notFound
        }
        
        guard httpResponse.statusCode == 204 else {
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        isConnected = true
    }
}

// MARK: - API Errors

enum APIError: LocalizedError {
    case badRequest
    case notFound
    case unexpectedStatusCode(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request to server"
        case .notFound:
            return "Resource not found"
        case .unexpectedStatusCode(let code):
            return "Unexpected status code: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
