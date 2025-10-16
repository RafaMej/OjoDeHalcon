//
//  DataModels.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 14/10/25.
//

// MARK: - Data Models
import Foundation
import SwiftUI
import FirebaseFirestore

// MARK: - User Models

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    var email: String
    var displayName: String?
    var photoURL: String?
    var favoriteTeams: [String]
    var matchesAnalyzed: Int
    var savedAnalyses: Int
    var consecutiveDays: Int
    var lastActiveDate: Date
    var createdAt: Date
    var fcmToken: String?
    var preferences: UserPreferences
    
    init(uid: String, email: String, displayName: String? = nil) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.favoriteTeams = []
        self.matchesAnalyzed = 0
        self.savedAnalyses = 0
        self.consecutiveDays = 0
        self.lastActiveDate = Date()
        self.createdAt = Date()
        self.preferences = UserPreferences()
    }
}

struct UserPreferences: Codable {
    var notificationsEnabled: Bool
    var matchReminders: Bool
    var goalAlerts: Bool
    var newsNotifications: Bool
    var favoriteTeamsOnly: Bool
    var darkModeEnabled: Bool
    var language: String
    var autoTranslate: Bool
    
    init() {
        self.notificationsEnabled = true
        self.matchReminders = true
        self.goalAlerts = true
        self.newsNotifications = true
        self.favoriteTeamsOnly = false
        self.darkModeEnabled = true
        self.language = "es"
        self.autoTranslate = false
    }
}

struct UserStats: Codable {
    var totalMatches: Int
    var totalAnalysisTime: TimeInterval
    var averageAnalysisPerMatch: TimeInterval
    var detectionsCount: Int
    var sharesCount: Int
    var favoriteFormation: String?
    
    init() {
        self.totalMatches = 0
        self.totalAnalysisTime = 0
        self.detectionsCount = 0
        self.sharesCount = 0
        self.averageAnalysisPerMatch = 0
    }
}

// MARK: - Match Models

struct Match: Codable, Identifiable {
    @DocumentID var id: String?
    var matchId: String
    var homeTeam: Team
    var awayTeam: Team
    var homeScore: Int
    var awayScore: Int
    var status: MatchStatus
    var currentMinute: Int?
    var addedTime: Int?
    var startTime: Date
    var competition: Competition
    var venue: Venue?
    var attendance: Int?
    var referee: String?
    var weather: Weather?
    var events: [MatchEvent]
    var statistics: MatchStatistics?
    var lineups: Lineups?
    
    var displayTime: String {
        switch status {
        case .upcoming:
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: startTime)
        case .live:
            if let minute = currentMinute, let added = addedTime, added > 0 {
                return "\(minute)+\(added)'"
            } else if let minute = currentMinute {
                return "\(minute)'"
            }
            return "EN VIVO"
        case .finished:
            return "FINAL"
        case .halftime:
            return "DESCANSO"
        case .postponed:
            return "POSPUESTO"
        case .cancelled:
            return "CANCELADO"
        }
    }
}

enum MatchStatus: String, Codable {
    case upcoming = "upcoming"
    case live = "live"
    case finished = "finished"
    case halftime = "halftime"
    case postponed = "postponed"
    case cancelled = "cancelled"
}

struct Team: Codable, Identifiable {
    var id: String
    var name: String
    var shortName: String
    var code: String // ISO 3166-1 alpha-2 or 3-letter code
    var flag: String // Emoji flag
    var logo: String? // URL
    var ranking: Int?
    var confederation: Confederation
    var coach: String?
    
    init(id: String, name: String, shortName: String, code: String, flag: String) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.code = code
        self.flag = flag
        self.confederation = .none
    }
}

enum Confederation: String, Codable {
    case uefa = "UEFA"
    case conmebol = "CONMEBOL"
    case concacaf = "CONCACAF"
    case caf = "CAF"
    case afc = "AFC"
    case ofc = "OFC"
    case none = "None"
}

struct Competition: Codable {
    var id: String
    var name: String
    var type: CompetitionType
    var season: String
    var logo: String?
    
    enum CompetitionType: String, Codable {
        case worldCup = "World Cup"
        case continental = "Continental"
        case league = "League"
        case cup = "Cup"
        case friendly = "Friendly"
    }
}

struct Venue: Codable {
    var name: String
    var city: String
    var country: String
    var capacity: Int?
    var image: String?
}

struct Weather: Codable {
    var temperature: Double
    var condition: String
    var humidity: Int
    var windSpeed: Double
}

// MARK: - Match Event Models

struct MatchEvent: Codable, Identifiable {
    var id: String
    var minute: Int
    var addedTime: Int?
    var type: EventType
    var team: String // Team ID
    var player: Player?
    var secondPlayer: Player? // For substitutions
    var description: String
    var videoURL: String?
    
    enum EventType: String, Codable {
        case goal = "goal"
        case ownGoal = "own_goal"
        case penalty = "penalty"
        case missedPenalty = "missed_penalty"
        case yellowCard = "yellow_card"
        case redCard = "red_card"
        case substitution = "substitution"
        case var_ = "var"
        case injury = "injury"
        case offside = "offside"
    }
    
    var icon: String {
        switch type {
        case .goal, .penalty: return "soccerball.circle.fill"
        case .ownGoal: return "soccerball.circle.inverse"
        case .missedPenalty: return "xmark.circle"
        case .yellowCard: return "square.fill"
        case .redCard: return "square.fill"
        case .substitution: return "arrow.left.arrow.right"
        case .var_: return "tv.fill"
        case .injury: return "cross.case.fill"
        case .offside: return "flag.fill"
        }
    }
}

struct Player: Codable, Identifiable {
    var id: String
    var name: String
    var number: Int?
    var position: Position
    var photo: String?
    var age: Int?
    var nationality: String?
    
    enum Position: String, Codable {
        case goalkeeper = "GK"
        case defender = "DF"
        case midfielder = "MF"
        case forward = "FW"
    }
}

// MARK: - Match Statistics

struct MatchStatistics: Codable {
    var possession: (home: Int, away: Int)
    var shots: (home: Int, away: Int)
    var shotsOnTarget: (home: Int, away: Int)
    var corners: (home: Int, away: Int)
    var fouls: (home: Int, away: Int)
    var offsides: (home: Int, away: Int)
    var yellowCards: (home: Int, away: Int)
    var redCards: (home: Int, away: Int)
    var passes: (home: Int, away: Int)
    var passAccuracy: (home: Double, away: Double)
    
    init() {
        self.possession = (0, 0)
        self.shots = (0, 0)
        self.shotsOnTarget = (0, 0)
        self.corners = (0, 0)
        self.fouls = (0, 0)
        self.offsides = (0, 0)
        self.yellowCards = (0, 0)
        self.redCards = (0, 0)
        self.passes = (0, 0)
        self.passAccuracy = (0.0, 0.0)
    }
}

// MARK: - Lineup Models

struct Lineups: Codable {
    var home: TeamLineup
    var away: TeamLineup
}

struct TeamLineup: Codable {
    var formation: String // e.g., "4-3-3"
    var startingXI: [PlayerLineup]
    var substitutes: [PlayerLineup]
    var coach: String
}

struct PlayerLineup: Codable, Identifiable {
    var id: String
    var player: Player
    var position: Position
    var x: Double // Normalized position (0-1)
    var y: Double // Normalized position (0-1)
    
    struct Position: Codable {
        var gridX: Int // Grid position (e.g., 1-5)
        var gridY: Int // Grid position (e.g., 1-11)
    }
}

// MARK: - News Models

struct NewsItem: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var summary: String?
    var author: String?
    var source: String
    var imageURL: String?
    var videoURL: String?
    var publishedAt: Date
    var tags: [String]
    var relatedTeams: [String]
    var relatedPlayers: [String]
    var category: NewsCategory
    var views: Int
    var likes: Int
    
    enum NewsCategory: String, Codable {
        case breakingNews = "Breaking News"
        case matchPreview = "Match Preview"
        case matchReview = "Match Review"
        case transfer = "Transfer"
        case interview = "Interview"
        case analysis = "Analysis"
        case other = "Other"
    }
}

// MARK: - AI Detection Models

struct Detection: Identifiable {
    let id = UUID()
    var boundingBox: CGRect
    var normalizedBox: CGRect
    var label: DetectionLabel
    var confidence: Float
    var trackingID: Int?
    var team: TeamSide?
    var timestamp: Date
    
    enum DetectionLabel: String {
        case player = "player"
        case ball = "ball"
        case referee = "referee"
        case goalpost = "goalpost"
    }
    
    enum TeamSide: String {
        case home = "home"
        case away = "away"
        case neutral = "neutral"
    }
}

struct TrackedObject: Identifiable {
    let id: Int
    var detections: [Detection]
    var trajectory: [CGPoint]
    var averageVelocity: CGVector
    var lastSeen: Date
    var classification: Detection.DetectionLabel
    var team: Detection.TeamSide?
    
    var currentPosition: CGPoint? {
        trajectory.last
    }
}

struct AnalysisSession: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var matchId: String?
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval
    var totalDetections: Int
    var averageFPS: Double
    var snapshots: [String] // URLs to saved images
    var insights: [TacticalInsight]
    var metadata: AnalysisMetadata
}

struct AnalysisMetadata: Codable {
    var deviceModel: String
    var osVersion: String
    var appVersion: String
    var modelVersion: String
    var averageConfidence: Float
}

struct TacticalInsight: Codable, Identifiable {
    var id: String
    var timestamp: TimeInterval // Seconds from start
    var type: InsightType
    var description: String
    var players: [String] // Player IDs
    var confidence: Float
    
    enum InsightType: String, Codable {
        case formationChange = "Formation Change"
        case defensivePress = "Defensive Press"
        case counterAttack = "Counter Attack"
        case buildup = "Build-up Play"
        case offside = "Offside"
        case setpiece = "Set Piece"
    }
}

// MARK: - Translation Models

struct TranslatedComment: Codable, Identifiable {
    var id: String
    var matchId: String
    var timestamp: TimeInterval
    var speaker: String?
    var originalText: String
    var originalLanguage: String
    var translatedText: String
    var targetLanguage: String
    var confidence: Float
    var context: CommentContext
    
    enum CommentContext: String, Codable {
        case goal = "goal"
        case card = "card"
        case substitution = "substitution"
        case general = "general"
        case analysis = "analysis"
    }
}

// MARK: - Tournament Models

struct Tournament: Codable, Identifiable {
    var id: String
    var name: String
    var edition: String
    var startDate: Date
    var endDate: Date
    var host: String
    var logo: String?
    var groups: [Group]?
    var knockoutStage: KnockoutStage?
    var topScorers: [TopScorer]
}

struct Group: Codable, Identifiable {
    var id: String
    var name: String // "Group A"
    var standings: [Standing]
}

struct Standing: Codable, Identifiable {
    var id: String
    var team: Team
    var played: Int
    var won: Int
    var drawn: Int
    var lost: Int
    var goalsFor: Int
    var goalsAgainst: Int
    var goalDifference: Int
    var points: Int
    var form: [MatchResult] // Last 5 matches
    var qualified: Bool
    
    enum MatchResult: String, Codable {
        case win = "W"
        case draw = "D"
        case loss = "L"
    }
}

struct KnockoutStage: Codable {
    var roundOf16: [KnockoutMatch]
    var quarterFinals: [KnockoutMatch]
    var semiFinals: [KnockoutMatch]
    var thirdPlace: KnockoutMatch?
    var final: KnockoutMatch?
}

struct KnockoutMatch: Codable, Identifiable {
    var id: String
    var homeTeam: Team?
    var awayTeam: Team?
    var homeScore: Int?
    var awayScore: Int?
    var penalties: (home: Int, away: Int)?
    var winner: Team?
    var date: Date
}

struct TopScorer: Codable, Identifiable {
    var id: String
    var player: Player
    var team: Team
    var goals: Int
    var assists: Int
    var matchesPlayed: Int
}

// MARK: - Notification Models

struct AppNotification: Codable, Identifiable {
    var id: String
    var type: NotificationType
    var title: String
    var body: String
    var data: [String: String]?
    var imageURL: String?
    var actionURL: String?
    var timestamp: Date
    var read: Bool
    
    enum NotificationType: String, Codable {
        case matchReminder = "match_reminder"
        case goalAlert = "goal_alert"
        case newsUpdate = "news_update"
        case analysisComplete = "analysis_complete"
        case system = "system"
    }
}

// MARK: - Social Models

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var userName: String
    var userPhoto: String?
    var content: String
    var matchId: String?
    var newsId: String?
    var timestamp: Date
    var likes: Int
    var replies: Int
}

struct Share: Codable {
    var userId: String
    var contentId: String
    var contentType: ShareType
    var platform: String
    var timestamp: Date
    
    enum ShareType: String, Codable {
        case match = "match"
        case news = "news"
        case analysis = "analysis"
        case stats = "stats"
    }
}

// MARK: - App Configuration Models

struct AppConfig: Codable {
    var minAppVersion: String
    var latestAppVersion: String
    var forceUpdate: Bool
    var maintenanceMode: Bool
    var features: FeatureFlags
    var apiEndpoints: APIEndpoints
}

struct FeatureFlags: Codable {
    var aiAnalysisEnabled: Bool
    var translationEnabled: Bool
    var socialFeedEnabled: Bool
    var notificationsEnabled: Bool
    var betaFeatures: Bool
}

struct APIEndpoints: Codable {
    var baseURL: String
    var matchesAPI: String
    var newsAPI: String
    var statsAPI: String
    var translationAPI: String
}

// MARK: - Error Models

struct AppError: Error, Identifiable {
    var id = UUID()
    var code: String
    var message: String
    var details: String?
    var timestamp: Date
    
    init(code: String, message: String, details: String? = nil) {
        self.code = code
        self.message = message
        self.details = details
        self.timestamp = Date()
    }
}

// MARK: - Response Models

struct APIResponse<T: Codable>: Codable {
    var success: Bool
    var data: T?
    var error: APIError?
    var timestamp: Date
    
    struct APIError: Codable {
        var code: String
        var message: String
    }
}

struct PaginatedResponse<T: Codable>: Codable {
    var data: [T]
    var page: Int
    var pageSize: Int
    var totalPages: Int
    var totalItems: Int
    var hasNext: Bool
    var hasPrevious: Bool
}

// MARK: - Extensions

extension User {
    var isNewUser: Bool {
        let daysSinceCreation = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        return daysSinceCreation < 7
    }
    
    var hasActivePremium: Bool {
        // Placeholder for premium subscription check
        return false
    }
}

extension Match {
    var isLive: Bool {
        return status == .live
    }
    
    var isFinished: Bool {
        return status == .finished
    }
    
    var displayScore: String {
        return "\(homeScore) - \(awayScore)"
    }
}

extension Detection {
    var displayConfidence: String {
        return String(format: "%.0f%%", confidence * 100)
    }
}

// MARK: - Sample Data (for previews and testing)

extension Team {
    static let sampleTeams = [
        Team(id: "ARG", name: "Argentina", shortName: "ARG", code: "ARG", flag: "🇦🇷"),
        Team(id: "BRA", name: "Brasil", shortName: "BRA", code: "BRA", flag: "🇧🇷"),
        Team(id: "FRA", name: "Francia", shortName: "FRA", code: "FRA", flag: "🇫🇷"),
        Team(id: "ESP", name: "España", shortName: "ESP", code: "ESP", flag: "🇪🇸"),
        Team(id: "MEX", name: "México", shortName: "MEX", code: "MEX", flag: "🇲🇽")
    ]
}

extension Match {
    static var sample: Match {
        Match(
            matchId: "sample-123",
            homeTeam: Team.sampleTeams[0],
            awayTeam: Team.sampleTeams[1],
            homeScore: 2,
            awayScore: 1,
            status: .live,
            currentMinute: 78,
            startTime: Date(),
            competition: Competition(
                id: "wc2026",
                name: "FIFA World Cup 2026",
                type: .worldCup,
                season: "2026"
            ),
            events: [],
            statistics: MatchStatistics()
        )
    }
}
