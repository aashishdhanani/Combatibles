//
//  BattleQuestionView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import SwiftUI

struct BattleQuestionView: View {
    @EnvironmentObject var viewModel: ViewModel
    var question: question
            
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            HStack{
                Text("Question \(viewModel.currentQuestionIndex + 1)")
                    .font(.title)
                    .bold()
                Spacer()
                Text("\(viewModel.secondsLeftInRound)")
                    .font(.title2)
                    .padding()
            }
            Text("\(question.question)")
                .font(.title2)
                .multilineTextAlignment(.leading)
            ForEach(question.choices, id: \.self){ choice in
                Button {
                    viewModel.answerForThisRound = choice
                    print(choice)
                } label: {
                    HStack{
                        Spacer()
                        Text("\(choice)")
                            .bold()
                        Spacer()
                    }
                    .padding(20)
                    .background(viewModel.answerForThisRound == choice ? Color("light_grey") : Color("very_light_grey"))
                    .cornerRadius(10)
                }
            }
        }
        .padding(12)
    }
}

#Preview {
    BattleQuestionView(question: question(id:4, userID: 0, question: "What is Quang's favorite ice cream flavor?", choices: ["Pistachio", "Mint Chocolate Chip", "Chocolate", "Vanilla"], answer: "Pistachio"))
}
