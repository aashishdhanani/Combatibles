//
//  AddPersonCard.swift
//  combatible
//
//  Created by Aiden Seibel on 4/20/24.
//

import SwiftUI

struct AddPersonCard: View {
    var body: some View {
        VStack{
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                .cornerRadius(UIScreen.main.bounds.width * 0.10)
                .clipped()
                .padding(.top, 5)
                .opacity(0.50)
            
            VStack(alignment: .leading){
                Text("Add person")
                    .foregroundStyle(.gray)
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
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [7]))
                .foregroundColor(Color(UIColor.blue))
        )
    }
}

#Preview {
    AddPersonCard()
}
