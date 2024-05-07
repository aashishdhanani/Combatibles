//
//  RoundResultsView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/22/24.
//

import SwiftUI

struct RoundResultsView: View {
    var battle: battle
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            Text("Round 1 Results")
                .bold()
            
            HStack{
                // team 1
                VStack{
                    PersonCardSmall(user: battle.team1Player1, backgroundColor: .red.opacity(0.50))
                    PersonCardSmall(user: battle.team1Player2, backgroundColor: .green.opacity(0.50))
                }
                
                Spacer()
                
                // team 2
                VStack{
                    PersonCardSmall(user: battle.team2Player1, backgroundColor: .green.opacity(0.50))
                    PersonCardSmall(user: battle.team2Player2, backgroundColor: .red.opacity(0.50))
                }
            }
        }
        .padding(7)
        .padding(.top, 5)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    RoundResultsView(battle: sampleBattles[0])
}
