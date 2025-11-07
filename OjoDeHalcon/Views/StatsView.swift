//
//  StatsView.swift
//  OjoDeHalcon
//
//  Created by Rafael Mejía López on 14/10/25.
//
import SwiftUI

struct StatsView: View {
    @State private var selectedTab = 0
    let tabs = ["Grupos", "Eliminatorias", "Jugadores", "Torneo"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.tacticalBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(AppTheme.gloryGold)
                        Text("Estadísticas del Mundial")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.whiteSharp)
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text("Qatar 2022")
                    }
                    .foregroundColor(AppTheme.whiteSharp)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppTheme.championBurgundy)
                    .cornerRadius(16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<tabs.count, id: \.self) { index in
                                Button(action: { selectedTab = index }) {
                                    Text(tabs[index])
                                        .foregroundColor(selectedTab == index ? AppTheme.tacticalBlack : AppTheme.whiteSharp)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(selectedTab == index ? AppTheme.gloryGold : Color.clear)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    ScrollView {
                        GroupStandings()
                    }
                }
            }
        }
    }
}

struct GroupStandings: View {
    var body: some View {
        VStack(spacing: 16) {
            GroupCard(
                name: "Grupo A",
                teams: [
                    ("🇳🇱", "Países Bajos", "2V 1E 0D", "7 pts", "Clasificado"),
                    ("🇸🇳", "Senegal", "0V 0E 3D", "6 pts", "Clasificado"),
                    ("🇶🇦", "Qatar", "1V 1E 1D", "4 pts", nil),
                    ("🇪🇨", "Ecuador", "1V 1E 1D", "4 pts", nil)
                ]
            )
            
            GroupCard(
                name: "Grupo B",
                teams: [
                    ("🏴󠁧󠁢󠁥󠁮󠁧󠁿", "Inglaterra", "2V 1E 0D", "7 pts", "Clasificado"),
                    ("🇺🇸", "Estados Unidos", "1V 2E 0D", "5 pts", "Clasificado")
                ]
            )
        }
        .padding()
    }
}

struct GroupCard: View {
    let name: String
    let teams: [(flag: String, name: String, record: String, points: String, status: String?)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(AppTheme.gloryGold)
                Text(name)
                    .font(.headline)
                    .foregroundColor(AppTheme.whiteSharp)
            }
            
            ForEach(teams.indices, id: \.self) { index in
                TeamRow(team: teams[index])
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack.opacity(0.5))
        .cornerRadius(12)
    }
}

struct TeamRow: View {
    let team: (flag: String, name: String, record: String, points: String, status: String?)
    
    var body: some View {
        HStack {
            Text(team.flag)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .foregroundColor(AppTheme.whiteSharp)
                    .fontWeight(.semibold)
                Text(team.record)
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(team.points)
                    .foregroundColor(AppTheme.gloryGold)
                    .fontWeight(.bold)
                Text("3 PJ")
                    .font(.caption)
                    .foregroundColor(AppTheme.whiteSharp.opacity(0.6))
            }
            
            if let status = team.status {
                Text(status)
                    .font(.caption)
                    .foregroundColor(AppTheme.tacticalBlack)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(AppTheme.tacticalBlack)
        .cornerRadius(8)
    }
}

#Preview {
    StatsView()
}
