//
//  BattleCard.swift
//  combatible
//
//  Created by Aiden Seibel on 4/15/24.
//

import SwiftUI

struct BattleCard: View {
    var battle: battle
    
    var body: some View {
        VStack(alignment: .leading){
            // if the battle is ongoing, there is no result
            if !battle.hasEnded{
                Text("Ongoing - \(timeSince(date: battle.startTime)) in")
                    .bold()
            }
//            else{
//                if battle.winners == 1{
//                    Text("Victory!")
//                        .bold()
//                }else if battle.winners == 2{
//                    Text("Defeat!")
//                        .bold()
//                }
//            }
            
            HStack{
                // team 1
                VStack{
                    PersonCardSmall(user: battle.team1Player1, backgroundColor: Color("light_grey"))
                    PersonCardSmall(user: battle.team1Player2, backgroundColor: Color("light_grey"))
                }
                
                Spacer()
                
                Text("vs.")
                    .font(.system(size: 16))
                
                Spacer()
                
                // team 2
                VStack{
                    PersonCardSmall(user: battle.team2Player1, backgroundColor: Color("light_grey"))
                    PersonCardSmall(user: battle.team2Player2, backgroundColor: Color("light_grey"))
                }
            }
        }
        .padding(7)
        .padding(.top, 5)
        .background(Color("very_light_grey"))
        .cornerRadius(10)
    }
}

#Preview {
    BattleCard(battle: sampleBattles[0])
}
