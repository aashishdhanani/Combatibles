//
//  ViewUserView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/20/24.
//

import SwiftUI

struct ViewUserView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var user: user
        
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 30){
                HStack(alignment: .top, spacing: 20){
                    Image(user.imageString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.30, height: UIScreen.main.bounds.width * 0.30)
                        .cornerRadius(UIScreen.main.bounds.width * 0.15)
                        .clipped()
                    VStack(alignment: .leading, spacing: 7){
                        Text("\(user.firstName)")
                            .bold()
                            .font(.title2)
                            .lineLimit(1)
                        Text("\(user.friends.count) friends")
                            .font(.system(size: 14))
                            .lineLimit(1)
                        HStack(spacing: 5){
                            Text("Status: ")
                                .font(.system(size: 14))
                                .lineLimit(1)
                            Text("\(user.onlineStatus ? "Online" : "Offline")")
                                .foregroundStyle(user.onlineStatus ? .green : .red)
                                .bold()
                                .font(.system(size: 14))
                                .lineLimit(1)
                        }
                    }
                    Spacer()
                }
                
                Button {
                    if user.onlineStatus{
                        viewModel.addToBattleSetup(user: user)
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text("Battle with \(user.firstName)")
                            .foregroundStyle(.white)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(user.onlineStatus ? .blue : .gray)
                    .cornerRadius(10)
                }

                
                Group{
                    Text("Recent battles")
                        .font(.title2)
                        .bold()
                        .lineLimit(1)
                    ForEach(user.battleLog, id: \.self){ battle in
                        BattleCard(battle: sampleBattles[0])
                    }
                    
                    if user.battleLog.count == 0{
                        Text("No recent battles.")
                    }
                }
            }
            .padding(12)
        }
    }
}

#Preview {
    ViewUserView(user: sampleUsers[0])
}
