//
//  OnboardingQuestions.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import SwiftUI

struct OnboardingQuestionsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: ViewModel
    
    @State var interests: String = ""
    @State var bio: String = ""
    @State var movie: String = ""
    
    var body: some View {
        ZStack{
            Color(hex: "92D1C3")
                .ignoresSafeArea()
            
            ScrollView{
                VStack(alignment: .leading, spacing: 50){
                    VStack(alignment: .leading, spacing: 20){
                        Text("Finish your profile")
                            .font(.title)
                            .bold()
                            .shadow(radius: 2)
                        Text("Combatibles is a question-based game. In order to play, you must answer a few questions about yourself.")
                        //                    .bold()
                            .shadow(radius: 2)
                        Text("These are just defaults that you can change at any time, so don't worry!")
                        //                    .bold()
                            .shadow(radius: 2)
                    }.padding(10).background(Color(hex: "92D1C3")).cornerRadius(10)
                    
                    
                    
                    Group{
                        VStack(alignment: .leading, spacing: 50){
                            VStack(alignment: .leading){
                                Text("What are your interests/hobbies?")
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
                                Text("Tell us a little bit about yourself.")
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
                                Text("Tell us your favorite movie.")
                                    .font(.title2)
                                    .bold()
                                TextField("Enter movie...", text: $movie)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                            .background(Color("very_light_grey"))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            if allFieldsValid(){
                                viewModel.onboardUser(interests: interests, bio: bio, movie: movie)
                            }
                        }, label: {
                            Spacer()
                            HStack{
                                Spacer()
                                Text("Submit")
                                    .bold()
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .frame(maxWidth: 100, maxHeight: 300)
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
                }
                .padding()
            }
        }
        }
        
        
        func allFieldsValid() -> Bool{
            return interests != "" && bio != "" && movie != ""
        }
    
   }


#Preview {
    OnboardingQuestionsView()
}

