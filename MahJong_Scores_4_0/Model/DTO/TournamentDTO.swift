//
//  TournamentDTO.swift
//  MahJong_Scores_4_0
//
//  Data Transfer Object for Tournament serialization
//

import Foundation

// Data Transfer Object for Score (Codable)
public struct ScoreDTO: Codable, Identifiable {
    public var id: UUID
    var name: String
    var game: Int
    var score: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, game, score
    }
}

// Data Transfer Object for Tournament (Codable)
public struct TournamentDTO: Codable, Identifiable {
    public var id: UUID
    
    // Tournament wide settings
    var rotateClockwise: Bool?
    var ruleSet: String?
    var startDate: String?
    
    // Tournament wide values
    var scheduleItem: Int
    var lastGame: Int?
    
    // Player names
    var fpName: String?
    var spName: String?
    var tpName: String?
    var lpName: String?
    
    // Game values
    var windPlayer: [String]?
    var currentWind: String?
    var players: [String]?
    var winds: [String]?
    var gameWinnerName: String?
    
    var ptScore: [String: Int]?
    var pgScore: [String: Int]?
    var windsToPlayersInGame: [String: String]?
    var playersToWindsInGame: [String: String]?
    
    // Scores
    var fpScores: [ScoreDTO]?
    var spScores: [ScoreDTO]?
    var tpScores: [ScoreDTO]?
    var lpScores: [ScoreDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id, rotateClockwise, ruleSet, startDate
        case scheduleItem, lastGame
        case fpName, spName, tpName, lpName
        case windPlayer, currentWind, players, winds, gameWinnerName
        case ptScore, pgScore, windsToPlayersInGame, playersToWindsInGame
        case fpScores, spScores, tpScores, lpScores
    }
}

// Extension to convert Tournament to TournamentDTO
extension Tournament {
    func toDTO() -> TournamentDTO {
        return TournamentDTO(
            id: UUID(), // Generate new UUID for DTO
            rotateClockwise: self.rotateClockwise,
            ruleSet: self.ruleSet,
            startDate: self.startDate,
            scheduleItem: self.scheduleItem,
            lastGame: self.lastGame,
            fpName: self.fpName,
            spName: self.spName,
            tpName: self.tpName,
            lpName: self.lpName,
            windPlayer: self.windPlayer,
            currentWind: self.currentWind,
            players: self.players,
            winds: self.winds,
            gameWinnerName: self.gameWinnerName,
            ptScore: self.ptScore,
            pgScore: self.pgScore,
            windsToPlayersInGame: self.windsToPlayersInGame,
            playersToWindsInGame: self.playersToWindsInGame,
            fpScores: self.fpScores?.map { ScoreDTO(id: $0.id, name: $0.name ?? "", game: $0.game ?? 0, score: $0.score ?? 0) },
            spScores: self.spScores?.map { ScoreDTO(id: $0.id, name: $0.name ?? "", game: $0.game ?? 0, score: $0.score ?? 0) },
            tpScores: self.tpScores?.map { ScoreDTO(id: $0.id, name: $0.name ?? "", game: $0.game ?? 0, score: $0.score ?? 0) },
            lpScores: self.lpScores?.map { ScoreDTO(id: $0.id, name: $0.name ?? "", game: $0.game ?? 0, score: $0.score ?? 0) }
        )
    }
}
