//
//  LoginSignUpView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import SwiftUI

struct LoginSignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: ViewModel
    
    @State var logInUsername:String = ""
    @State var logInPassword:String = ""

    @State var signUpUsername:String = ""
    @State var signUpEmail:String = ""
    @State var signUpPassword:String = ""
    @State var signUpPasswordConfirm:String = ""
    @State var signUpDOB:Date = Date()
    @State var signUpLocation:String = ""
    @State var firstName: String = ""
    
    @State var onboardingMode: String = "Log In"
    var onboardingOptions: [String] = ["Log In", "Sign Up"]
    
    @State var fieldsAreNotValid: Bool = false
    
    @State var showProgressView = false
    
    var body: some View {
        ZStack{
            Color(hex: "B47EB3")
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.2))
            Circle()
                .scale(1.25)
                .foregroundColor(.white)
            
            
            
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 30){
                    HStack{
                        Spacer()
                        Text("Welcome to Combatibles!")
                            .bold()
                            .font(.title)
                        Spacer()
                    }
                    
                    Picker("driving", selection: $onboardingMode) {
                        ForEach(onboardingOptions, id: \.self){option in
                            Text("\(option)")
                                
                        }
                        
                    }.pickerStyle(.segmented).shadow(radius: 8)
                    
                    
                    if onboardingMode == "Log In"{
                        // log in
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        VStack(alignment: .center, spacing: 10){
                            
                            Text("Log in")
                                .bold()
                                .font(.title2)
                            TextField("Username or email...", text: $logInUsername)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
                            SecureField("Password...", text: $logInPassword)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
                            
                            
                            if !showProgressView{
                                Button {
                                    if logInFieldsAreValid(){
                                        showProgressView = true
                                        viewModel.signInUser(username: logInUsername, password: logInPassword)
                                    }
                                } label: {
                                    Spacer()
                                    HStack{
                                        
                                        Text("Login")
                                            .font(.system(size: 24, weight: .bold, design: .default))
                                            .frame(maxWidth: 100, maxHeight: 300)
                                            .foregroundColor(Color.black)
                                            .padding(3)
                                        
                                    }
                                    
                                    
                                    .background(Color(hex: "FDF5BF"))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    Spacer()
                                    
                                }
                                
                            }
                            if showProgressView {
                                CircularProgressDemoView()
                            }
                        }
                        .padding(20)
                        .background(Color("very_light_grey"))
                        .cornerRadius(30)
                        
                        
                    }
                    
                    
                    
                    else{
                        // sign up
                        Spacer()
                        VStack(alignment: .center, spacing: 10){
                            Text("Sign up")
                                .bold()
                                .font(.title2)
                            TextField("First Name...", text: $firstName)
                                .autocorrectionDisabled()
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
                            TextField("Username...", text: $signUpUsername)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
                            TextField("Email...", text: $signUpEmail)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
                            SecureField("Password...", text: $signUpPassword)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
                            SecureField("Confirm Password...", text: $signUpPasswordConfirm)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
//                            DatePicker("Date of Birth", selection: $signUpDOB, displayedComponents: [.date])
//                            TextField("Location", text: $signUpLocation)
//                                .autocorrectionDisabled()
//                                .padding(10)
//                                .background(.white)
//                                .cornerRadius(10)

                          
                                
                            if !showProgressView {
                                Button {
                                    if signUpFieldsAreValid(){
                                        showProgressView = true
                                        viewModel.signUpUser(username: signUpUsername, email: signUpEmail, password: signUpPassword, dob: signUpDOB, location: signUpLocation, firstName: firstName)
                                        
                                    }
                                } label: {
                                    Spacer()
                                    HStack{
                                        
                                        Text("Sign up")
                                            .font(.system(size: 24, weight: .bold, design: .default))
                                            .frame(maxWidth: 100, maxHeight: 300)
                                            .foregroundColor(Color.black)
                                            .padding(3)
                                        
                                    }
                                    
                                    
                                    .background(Color(hex: "FDF5BF"))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    Spacer()
                                    
                                }
                            }
                                Spacer()
                                if showProgressView {
                                    CircularProgressDemoView()
                                }
                            
                            
                        }
                        .padding(20)
                        .background(Color("very_light_grey"))
                        .cornerRadius(30)
                    }
                    
                    
                    if fieldsAreNotValid{
                        Text("Ensure all fields are valid.")
                            .foregroundStyle(.red)
                            .bold()
                    }
                }
                
            }
            .padding()
        }
        
    }
    
    func logInFieldsAreValid() -> Bool{
        if !logInUsername.isEmpty && !logInPassword.isEmpty{
            return true
        }
        fieldsAreNotValid = true
        return false
    }
    
    func signUpFieldsAreValid() -> Bool{
        if !signUpUsername.isEmpty && !signUpPassword.isEmpty && (signUpPassword == signUpPasswordConfirm){
            return true
        }
        fieldsAreNotValid = true
        return false
    }
}

#Preview {
    LoginSignUpView()
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
struct CircularProgressDemoView: View {
    @State private var progress = 0.6

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(.circular)
        }
    }
}
