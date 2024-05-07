//
//  PersonCardSmall.swift
//  combatible
//
//  Created by Aiden Seibel on 4/15/24.
//

import SwiftUI

struct PersonCardSmall: View {
    var user: user
    var backgroundColor: Color

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
            }
            
            Spacer()
        }
        .padding(5)
        .frame(width: UIScreen.main.bounds.width * 0.40, height: UIScreen.main.bounds.width * 0.125)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    PersonCardSmall(user: sampleUsers[0], backgroundColor: Color("very_light_grey"))
}
