//
//  user.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import Foundation

struct user: Identifiable, Codable, Hashable{
    static func == (lhs: user, rhs: user) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    var id: Int
    var firstName, username, email, imageString: String
    var onlineStatus: Bool
    
    var questions: [Int]
    var battleLog: [Int]
    var friends: [Int]
        
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case username = "username"
        case email = "email"
        case imageString = "photo_url"
        case onlineStatus = "is_active"
        case questions = "questions"
        case battleLog = "battles"
        case friends = "friends"
    }
    
    init(id: Int, firstName: String, username: String, email: String, imageString: String, onlineStatus: Bool, questions: [Int], battleLog: [Int], friends: [Int], points: Int) {
        self.id = id
        self.firstName = firstName
        self.username = username
        self.email = email
        self.imageString = imageString
        self.onlineStatus = onlineStatus
        self.questions = questions
        self.battleLog = battleLog
        self.friends = friends
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.imageString = try container.decode(String.self, forKey: .imageString)
        self.onlineStatus = try container.decode(Bool.self, forKey: .onlineStatus)
        self.questions = try container.decode([Int].self, forKey: .questions)
        self.battleLog = try container.decode([Int].self, forKey: .battleLog)
        self.friends = try container.decode([Int].self, forKey: .friends)
    }
}


var sampleUsers:[user] = [
    user(id: 1, firstName: "Quang", username: "quangle@gmail.com", email: "", imageString: "lequang", onlineStatus: false, questions: [], battleLog: [], friends: [], points: 1200),
    user(id: 2, firstName: "Aiden", username: "aseib", email: "", imageString: "aseib", onlineStatus: true, questions: [], battleLog: [], friends: [], points: 1400),
    user(id: 3, firstName: "Aashish", username: "aaheehee", email: "", imageString: "aashishi", onlineStatus: true, questions: [], battleLog: [], friends: [], points: 750),
    user(id: 4, firstName: "Matvei", username: "mattypop", email: "", imageString: "mattypop", onlineStatus: true, questions: [], battleLog: [], friends: [], points: 2400)
]
