//
//  NetworkingView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/15/24.
//

import SwiftUI

struct NetworkingTab: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 30){
                    Group{
                        Text("Recent battles")
                            .font(.title2)
                            .bold()
//                        BattleCard(battle: sampleBattles[0])
//                        BattleCard(battle: sampleBattles[0])
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Friends Online")
                            .bold()
                            .font(.title2)
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(sampleUsers, id: \.self){ user in
                                    NavigationLink(destination: ViewUserView(user: user)) {
                                        PersonCardMedium(user: user)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    
                    Divider()

                    VStack(alignment: .leading, spacing: 10){
                        Text("People you may know")
                            .font(.title2)
                            .bold()
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(sampleUsers, id: \.self){ user in
                                    NavigationLink(destination: ViewUserView(user: user)) {
                                        PersonCardMedium(user: user)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(12)
            }
            .navigationTitle("Nearby")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    NetworkingTab()
}
