//
//  MapNearbyCard.swift
//  combatible
//
//  Created by Aiden Seibel on 4/16/24.
//

import SwiftUI

struct PersonCardMedium: View {
    var user: user
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: user.imageString)) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                        .cornerRadius(UIScreen.main.bounds.width * 0.10)
                        .clipped()
                        .padding(.top, 5)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                        .cornerRadius(UIScreen.main.bounds.width * 0.10)
                        .clipped()
                        .padding(.top, 5)
                default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                        .cornerRadius(UIScreen.main.bounds.width * 0.10)
                        .clipped()
                        .padding(.top, 5)
                }
            }
            
            VStack(alignment: .leading){
                Text("\(user.firstName)")
                    .bold()
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(5)
        .padding(.top, 5)
        .frame(width: UIScreen.main.bounds.width * 0.30, height: UIScreen.main.bounds.width * 0.40)
        .background(Color("very_light_grey"))
        .cornerRadius(10)
    }
}

#Preview {
    PersonCardMedium(user: sampleUsers[0])
}
