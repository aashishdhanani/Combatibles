//
//  ProfileView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/15/24.
//

import SwiftUI

struct ProfileTab: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 30){
                    HStack(alignment: .top, spacing: 20){
                        AsyncImage(url: URL(string: viewModel.localUser?.imageString ?? "")) { phase in
                            switch phase {
                            case .failure:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.30, height: UIScreen.main.bounds.width * 0.30)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.15)
                                    .clipped()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.30, height: UIScreen.main.bounds.width * 0.30)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.15)
                                    .clipped()
                            default:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.30, height: UIScreen.main.bounds.width * 0.30)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.15)
                                    .clipped()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 7){
                            Text("\(getFirstName())")
                                .bold()
                                .font(.title2)
                                .lineLimit(1)
                            Text("\(viewModel.localUser?.username ?? "username")")
                                .font(.system(size: 14))
                                .lineLimit(1)
                            Text("\(viewModel.localUser?.friends.count ?? 0) friends")
                                .font(.system(size: 14))
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    
                    Group{
                        Text("Recent battles")
                            .font(.title2)
                            .bold()
                            .lineLimit(1)
                        ForEach(viewModel.localUser?.battleLog ?? [], id: \.self){ battle in
                            BattleCard(battle: sampleBattles[0])
                        }
                        if viewModel.localUser?.battleLog.count == 0{
                            Text("No recent battles.")
                        }
                    }
                    
                    NavigationLink(destination: UpdateUserProfileView()) {
                        Text("Update my profile")
                    }
                    
                    Divider()
                    
                    Button{
                        viewModel.fetchRandomQuestions(uid: viewModel.localUser?.id ?? 0, number_of_questions: 3)
                    } label: {
                        Text("Generate Questions")
                    }
                    
                    ForEach(viewModel.myQuestions, id: \.self){ question in
                        Text("\(question.question)")
                    }
                    
                    Divider()
                    
                    Button {
                        viewModel.localUser = nil
                        viewModel.hasOnboarded = false
                        viewModel.isLoggedIn = false
                    } label: {
                        Text("Sign out")
                            .bold()
                    }
                }
                .padding(12)
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func getFirstName() -> String{
        if let first = viewModel.localUser?.firstName{
            return first == "" ? "FirstName" : first
        }
        return "FirstName"
    }
    
}


#Preview {
    ProfileTab()
}
