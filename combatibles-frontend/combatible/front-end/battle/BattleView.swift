//
//  BattleView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import SwiftUI

struct BattleView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var battle: battle
    
    @State private var timer: Timer?
    
    var body: some View {
        if viewModel.roundsLeftInGame == 0{
            BattleEndView()
        }else{
            if viewModel.roundsLeftInGame > 0 {
                if viewModel.secondsLeftInRound > 0 && viewModel.isReadyForNextRound{
                    BattleQuestionView(question: viewModel.getCurrentQuestion() ?? viewModel.myQuestions[0])
                        .onAppear{
                            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                                viewModel.secondsLeftInRound -= 1
                                print(viewModel.secondsLeftInRound)
                            }
                        }
                }else{
                    BattleAnswerView(isCorrect: viewModel.checkAnswer())
                        .onAppear{
                            timer?.invalidate()
                            viewModel.isReadyForNextRound = false
                            print("answer view appears")
                            viewModel.roundsLeftInGame -= 1
                        }
                }
            }
        }
    }
}

#Preview {
    BattleView(battle: sampleBattles[0])
}
