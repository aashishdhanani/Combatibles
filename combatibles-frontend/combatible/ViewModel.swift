//
//  viewModel.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//


import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var localUser: user?
    @Published var authToken: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var hasOnboarded: Bool = false
    @Published var battleSetupTeam1Player2: user?
    @Published var battleSetupTeam2Player1: user?
    @Published var battleSetupTeam2Player2: user?
    @Published var currentBattle: battle?
    @Published var localUserFriends: [user] = []
    
    @Published var battleSetupTeamSelected: Int = -1
    @Published var battleSetupPlayerSelected: Int = -1
    
    @Published var answerForThisRound: String?
    @Published var trueAnswer: String?
    @Published var secondsLeftInRound: Int = 10
    @Published var roundsLeftInGame: Int = 3
    @Published var isReadyForNextRound: Bool = true
    @Published var allQuestions: [question] = []
    @Published var myQuestions: [question] = []
    @Published var currentQuestionIndex: Int = 0
    
    @Published var isCentral: Bool = true
    @Published var centralBluetoothModel: CentralBluetoothModel?
    @Published var peripheralBluetoothModel: PeripheralBluetoothModel?
    

    init(){
        if let local_username = UserDefaults.standard.string(forKey: "local_username"), let local_password = UserDefaults.standard.string(forKey: "local_password"){
            signInUser(username: local_username, password: local_password)
        }else{
            print("Could not sign in user")
        }
    }
    
    func addToBattleSetup(user: user) -> Bool{
        print("adding to battle setup")
        if battleSetupTeamSelected == 1 && battleSetupPlayerSelected == 2{
            battleSetupTeam1Player2 = user
            centralBluetoothModel?.addPeripheralToBattle(id: String(user.id), team: battleSetupTeamSelected, player: battleSetupPlayerSelected)
            return true
        }else if battleSetupTeamSelected == 2 && battleSetupPlayerSelected == 1{
            battleSetupTeam2Player1 = user
            centralBluetoothModel?.addPeripheralToBattle(id: String(user.id), team: battleSetupTeamSelected, player: battleSetupPlayerSelected)
            return true
        }else if battleSetupTeamSelected == 2 && battleSetupPlayerSelected == 2{
            battleSetupTeam2Player2 = user
            centralBluetoothModel?.addPeripheralToBattle(id: String(user.id), team: battleSetupTeamSelected, player: battleSetupPlayerSelected)
            return true
        }
        
        print("Could not add to battle ")
        return false
    }
    
    func startBattle(){
//        if let t1p1 = localUser, let t1p2 = battleSetupTeam1Player2, let t2p1 = battleSetupTeam2Player1, let t2p2 = battleSetupTeam2Player2{
            getAllQuestions(id1: 20, id2: 21, id3: 22, id4: 23) { fetched_questions in
                DispatchQueue.main.async{
                    print(fetched_questions)
                    
                    self.myQuestions = fetched_questions.filter { $0.userID == self.localUser?.id }
                    print("all questions")
                    print(fetched_questions)
                    
                    print("\n\n\nmy questions")
                    print(self.myQuestions)

                    self.currentBattle = battle(id: UUID(), startTime: Date.now, hasEnded: false, team1Player1: sampleUsers[0], team1Player2: sampleUsers[0], team2Player1: sampleUsers[0], team2Player2: sampleUsers[0], questions: fetched_questions, latitude: 0.0, longitude: 0.0)
                }
//            }
        }
    }
    
    // use the data model to sign in users and then set the userdefaults to remember them on launch
    func signInUser(username: String, password: String) {
        // call static post request function in datamodel
        DataModel.signInUser(username: username, password: password) { user, token in
            // Completion block is executed once the data model returns a response
            DispatchQueue.main.async {
                if let user = user {
                    // Set user defaults
                    UserDefaults.standard.set(username, forKey: "local_username")
                    UserDefaults.standard.set(password, forKey: "local_password")
                    
                    // Set other values
                    self.localUser = user
                    self.authToken = token
                    self.isLoggedIn = true
                    self.hasOnboarded = true
                    
                    self.centralBluetoothModel = CentralBluetoothModel()
                    
                    let userID:String = String(user.id)
                    self.peripheralBluetoothModel = PeripheralBluetoothModel(userID: userID)
                    
                    for friend in user.friends{
                        DataModel.getUser(userID: friend) { friend_obj in
                            if let friend_obj = friend_obj{
                                self.localUserFriends.append(friend_obj)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func signUpUser(username: String, email: String, password: String, dob: Date, location:String, firstName: String){
        // convert the DOB Date into a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dob_string: String = dateFormatter.string(from: dob)
        
        DataModel.signUpUser(username: username, email: email, password: password, dob_string: dob_string, location: location, firstName: firstName) { user, token in
            DispatchQueue.main.async {
                if let user = user {
                    // Set user defaults
                    UserDefaults.standard.set(username, forKey: "local_username")
                    UserDefaults.standard.set(password, forKey: "local_password")
                    
                    print("user received, logging in on front end...")
                    
                    // Set other values
                    self.localUser = user
                    self.authToken = token
                    self.isLoggedIn = true
                }
            }
        }
    }
    
    func onboardUser(interests: String, bio: String, movie: String){
        DataModel.rizz(authToken: authToken, interests: interests, bio: bio, movie: movie)
        
        hasOnboarded = true
    }
            
    
    func fetchRandomQuestions(uid: Int, number_of_questions: Int){
        DataModel.fetchRandomQuestions(authToken: authToken, uid: uid, number_of_questions: number_of_questions){ fetched_questions in
            DispatchQueue.main.async {
                self.myQuestions = fetched_questions
            }
        }
    }
    
    func updateUserProfile(args: [String: String]){
        let filtered_args = args.filter { !$0.value.isEmpty }

        DataModel.updateUserInfo(authToken: authToken, args: filtered_args)
    }
    
    func getAllQuestions(id1: Int, id2: Int, id3: Int, id4: Int, completion: @escaping ([question]) -> Void) {
        var all_questions: [question] = []
        
        var count = 0
        
        for uid in [id1, id2, id3, id4]{
            DataModel.fetchRandomQuestions(authToken: authToken, uid: uid, number_of_questions: 3){ fetched_question in
                all_questions.append(contentsOf: fetched_question)
                count += 1
                print(count)
                
                if count == 8{
                    print("all_questions")
                    print(all_questions)
                    
                    completion(all_questions)
                }
            }
        }
    }
    
    func getCurrentQuestion() -> question?{
        if currentQuestionIndex >= myQuestions.count - 1{
            return nil
        }
        
        currentQuestionIndex += 1
        let current_question = myQuestions[currentQuestionIndex]
        
        return current_question
    }
    
    func checkAnswer() -> Bool{
        return answerForThisRound == getCurrentQuestion()?.answer
    }
}
