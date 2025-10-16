//
//  LiveMatchData.swift
//  OjoDeHalcon
//
//  Created by Rosh on 16/10/25.
//

import SwiftUI

/// Contiene el conjunto de estadísticas cuantificables de un equipo en un momento dado para la simulación.
struct MatchStats: Hashable {
    var possession: Double = 0.5
    var shots: Int = 0
    var shotsOnTarget: Int = 0
    var passes: Int = 0
    var passAccuracy: Double = 0.0 // Aún no usado en el simulador, pero listo para el futuro
    var fouls: Int = 0
    var yellowCards: Int = 0
    var redCards: Int = 0
}

/// La fuente de verdad que representa el estado completo y en vivo del partido para el simulador.
struct LiveMatchData {
    var homeTeam: Team
    var awayTeam: Team
    var homeStats: MatchStats
    var awayStats: MatchStats
    var matchTime: Int // Minuto actual del partido

    /// Proporciona un estado inicial por defecto para las Previews y el arranque.
    static func placeholder() -> LiveMatchData {
        LiveMatchData(
            homeTeam: Team(
                id: "RC",
                name: "Real Cósmicos",
                shortName: "RCO",
                code: "RC",
                flag: "🌌"
            ),
            awayTeam: Team(
                id: "AN",
                name: "Atlético Nebulosa",
                shortName: "ANB",
                code: "ANB",
                flag: "🪐"
            ),
            homeStats: MatchStats(),
            awayStats: MatchStats(),
            matchTime: 0
        )
    }
}
