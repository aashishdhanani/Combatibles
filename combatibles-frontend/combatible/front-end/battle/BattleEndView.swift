//
//  BattleEndView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import SwiftUI

struct BattleEndView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack{
            if isWinner(){
                Color.green//.opacity(0.70)
                    .ignoresSafeArea()
            }else{
                Color.red//.opacity(0.70)
                    .ignoresSafeArea()
            }
            ScrollView{
                VStack(alignment: .center, spacing: 30){
                    Spacer()
                    
                    Text("\(isWinner() ? "Victory!" : "Defeat!")")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text("\(isWinner() ? "Nice one!" : "Better luck next time.")")
                        .foregroundStyle(.white)

                    Spacer()
                    
//                    ForEach(rounds, id: \.self){_ in
//                        RoundResultsView(battle: sampleBattles[0])
//                    }
//                    
//                    Spacer()
                    
                    Button {
                        viewModel.currentBattle?.hasEnded = true
                        viewModel.currentBattle = nil
                    } label: {
                        HStack{
                            Spacer()
                            Text("Return to Home")
                                .bold()
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(20)
                        .background(.blue)
                        .cornerRadius(10)
                    }
                }.padding(12)
            }
        }
    }
    
    func isWinner() -> Bool{
        return true
    }
}

#Preview {
    BattleEndView()
}
