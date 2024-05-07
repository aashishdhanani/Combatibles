//
//  UpdateUserProfileView.swift
//  combatible
//
//  Created by Aiden Seibel on 5/4/24.
//

import SwiftUI

struct UpdateUserProfileView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var bio = ""
    @State var favorite_quote = ""
    @State var pet_peeves = ""
    @State var dream_destination = ""
    @State var memorable_moments = ""
    @State var interests = ""
    @State var personality_traits = ""
    @State var favorite_movie = ""
    @State var favorite_book = ""
    @State var favorite_food = ""
    @State var virtues = ""
    @State var vices = ""
    @State var anecdote = ""
    
    var body: some View {
        NavigationView{
            
            ZStack{
                Color(hex: "92D1C3")
                    .ignoresSafeArea()
                ScrollView(.vertical){
                    VStack(alignment: .leading, spacing: 20){
                        VStack(alignment: .leading, spacing: 50){
                            VStack(alignment: .leading){
                                Text("My bio")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter bio...", text: $bio)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("My pet peeves")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter pet peeves...", text: $pet_peeves)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("My dream destination")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter dream destination...", text: $dream_destination)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("My memorable moments")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter memorable moments...", text: $memorable_moments)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("My interests")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter interests...", text: $interests)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("My favorites")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter movie...", text: $favorite_movie)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                                TextField("Enter book...", text: $favorite_book)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                                TextField("Enter food...", text: $favorite_food)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                                TextField("Enter favorite quote...", text: $favorite_quote)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                                
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("My vices")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter vices...", text: $vices)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("My virtues")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter virtues...", text: $virtues)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading){
                                Text("An anecdote about me")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter anecdote...", text: $anecdote)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            let args: [String: String] = [
                                "bio": bio,
                                "favorite_quote": favorite_quote,
                                "pet_peeves": pet_peeves,
                                "dream_destination": dream_destination,
                                "memorable_moments": memorable_moments,
                                "interests": interests,
                                "personality_traits": personality_traits,
                                "favorite_movie": favorite_movie,
                                "favorite_book": favorite_book,
                                "favorite_food": favorite_food,
                                "virtues": virtues,
                                "vices": vices,
                                "anecdote": anecdote,
                            ]
                            viewModel.updateUserProfile(args: args)
                        }, label: {
                            Spacer()
                            HStack{
                                Spacer()
                                Text("Save my profile")
                                    .bold()
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .frame(height: 50)
                                    .foregroundColor(Color.black)
                                    .padding(3)
                                Spacer()
                            }
                            .background(Color(hex: "FDF5BF"))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            Spacer()
                        })
                    }
                    .padding(15)
                    .navigationTitle("Update my Profile")
                    .navigationBarTitleDisplayMode(.large)
                }
            }
            
        }
        
    }
}
    
#Preview {
    UpdateUserProfileView()
}

