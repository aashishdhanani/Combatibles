//
//  SearchResultView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/20/24.
//

import SwiftUI

struct SearchResultView: View {
    var user: user
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: user.imageString)) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.10, height: UIScreen.main.bounds.width * 0.10)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                        .clipped()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.10, height: UIScreen.main.bounds.width * 0.10)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                        .clipped()
                default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.10, height: UIScreen.main.bounds.width * 0.10)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                        .clipped()
                }
            }
            
            VStack(alignment: .leading){
                Text("\(user.firstName)")
                    .bold()
                    .lineLimit(1)
                HStack(spacing: UIScreen.main.bounds.width * 0.05){
                    Text("\(user.friends.count) friends")
                        .font(.system(size: 10))
                    Text("\(user.onlineStatus ? "Online" : "Offline")")
                        .font(.system(size: 10))
                        .bold()
                        .foregroundStyle(user.onlineStatus ? .green : .red)
                }
            }
            
            Spacer()
        }
        .padding(5)
        .frame(height: UIScreen.main.bounds.width * 0.15)
        .background(Color("very_light_grey"))
        .cornerRadius(10)
    }
}

#Preview {
    SearchResultView(user: sampleUsers[0])
}
