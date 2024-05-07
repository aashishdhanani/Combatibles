//
//  battle.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import Foundation

struct battle: Identifiable, Decodable, Hashable{
    var id: UUID
    var startTime: Date
    var hasEnded: Bool
    
    var team1Player1: user
    var team1Player2: user
    var team2Player1: user
    var team2Player2: user
    
    var team1Player1Points: Int = 0
    var team1Player2Points: Int = 0
    var team2Player1Points: Int = 0
    var team2Player2Points: Int = 0
    
    var questions: [question]
    
    var latitude, longitude: Double
        
    static func == (lhs: battle, rhs: battle) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

var sampleBattles: [battle] = [
    battle(id: UUID(), startTime: Date.now, hasEnded: false, team1Player1: sampleUsers[0], team1Player2: sampleUsers[1], team2Player1: sampleUsers[2], team2Player2: sampleUsers[3], team1Player1Points: 0, team1Player2Points: 0, team2Player1Points: 0, team2Player2Points: 0, questions: [], latitude: 0.0, longitude: 0.0)
]
