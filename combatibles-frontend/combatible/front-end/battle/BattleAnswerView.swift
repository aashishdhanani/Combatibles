//
//  BattleAnswerView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import SwiftUI

struct BattleAnswerView: View {
    @EnvironmentObject var viewModel: ViewModel

    var isCorrect: Bool
        
    var body: some View {
        ZStack{
            if isCorrect{
                Color.green//.opacity(0.70)
                    .ignoresSafeArea()
            }else{
                Color.red//.opacity(0.70)
                    .ignoresSafeArea()
            }

            VStack(alignment: .center, spacing: 30){
                Spacer()
                
                Text("\(isCorrect ? "Correct!" : "Incorrect")")
                    .font(.title)
                    .foregroundStyle(.white)
                    .bold()
                Text("+\(isCorrect ? "1000" : "0") points")
                    .font(.title)
                    .foregroundStyle(.white)
                    .italic()
                
                VStack(spacing: 10){
                    Text("\(isCorrect ? "You got this!" : "The correct answer was:")")
                        .foregroundStyle(.white)
                    
                    if !isCorrect{
                        Text(viewModel.trueAnswer ?? "")
                            .foregroundStyle(.white)
                            .bold()
                            .italic()
                    }

                }
                
                Spacer()

//                RoundResultsView(battle: sampleBattles[0])
//                
//                Spacer()
                
                Button {
                    viewModel.isReadyForNextRound = true
                    viewModel.secondsLeftInRound = 10
                } label: {
                    HStack{
                        Spacer()
                        Text("Start the Next Round")
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

#Preview {
    BattleAnswerView(isCorrect: false)
}
