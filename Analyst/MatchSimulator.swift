// En: OjoDeHalcon/Analyst/MatchSimulator.swift

import Foundation
import Combine

/// Un actor que gestiona y simula el estado en tiempo real de un partido de fútbol.
actor MatchSimulator {
    
    /// Publica los cambios en los datos del partido para que los observadores (como el ViewModel) puedan reaccionar.
    @Published private(set) var matchData: LiveMatchData

    // FIX: Reemplazamos el Timer por un Task para un manejo moderno y seguro de la concurrencia.
    private var simulationTask: Task<Void, Error>?

    /// Inicializa el simulador con un estado de partido de ejemplo.
    init() {
        self.matchData = LiveMatchData.placeholder()
    }

    /// Inicia el ciclo de simulación del partido.
    func start() {
        // Nos aseguramos de no crear múltiples bucles de simulación.
        guard simulationTask == nil else { return }
        
        simulationTask = Task {
            // El bucle se ejecutará hasta que la tarea sea cancelada.
            while !Task.isCancelled {
                // Esperamos 5 segundos de forma asíncrona y segura.
                try await Task.sleep(for: .seconds(5))
                
                // Actualizamos el estado del partido.
                updateMatchState()
            }
        }
    }
    
    /// Detiene la simulación del partido.
    func stop() {
        simulationTask?.cancel()
        simulationTask = nil
    }

    /// El núcleo de la simulación. Esta función modifica las estadísticas de forma aleatoria.
    private func updateMatchState() {
        // Avanza el tiempo del partido, hasta un máximo de 90 minutos.
        guard matchData.matchTime < 90 else {
            stop()
            return
        }
        matchData.matchTime += 5 // Cada tick son 5 minutos de partido

        // --- Lógica de Simulación de Eventos (sin cambios) ---
        
        // 1. Simular cambio de posesión
        let possessionShift = Double.random(in: -0.08...0.08)
        matchData.homeStats.possession = max(0, min(1, matchData.homeStats.possession + possessionShift))
        matchData.awayStats.possession = 1.0 - matchData.homeStats.possession
        
        // 2. Simular pases
        matchData.homeStats.passes += Int.random(in: 15...40)
        matchData.awayStats.passes += Int.random(in: 15...40)
        
        // 3. Simular un tiro (más probable para el equipo con más posesión)
        if Double.random(in: 0...1) < (matchData.homeStats.possession * 0.7) {
            matchData.homeStats.shots += 1
            if Bool.random() {
                matchData.homeStats.shotsOnTarget += 1
            }
        }
        
        if Double.random(in: 0...1) < (matchData.awayStats.possession * 0.7) {
            matchData.awayStats.shots += 1
            if Bool.random() {
                matchData.awayStats.shotsOnTarget += 1
            }
        }
        
        // 4. Simular una falta
        if Int.random(in: 1...10) > 8 { // 20% de probabilidad
            if Bool.random() {
                matchData.homeStats.fouls += 1
            } else {
                matchData.awayStats.fouls += 1
            }
        }
    }
}
