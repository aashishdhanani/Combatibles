//
//  question.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import Foundation

struct question: Identifiable, Decodable, Hashable{
    var id: Int
    var userID: Int
    
    var question: String
    var answer: String
    var choices: [String]
    
    static func == (lhs: question, rhs: question) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case answer = "answer"
        case question = "question_content"
        case time_created = "time_created"
        case userID = "created_by"
        case wrong_answers = "wrong_answers"
    }
    
    init(id: Int, userID: Int, question: String, choices: [String], answer: String){
        self.id = id
        self.userID = userID
        self.question = question
        self.answer = answer
        self.choices = choices
    }
    
    init(id: Int, userID: Int, question: String, wrong_answers: String, answer: String){
        self.id = id
        self.userID = userID
        self.question = question
        self.answer = answer
        self.choices = wrong_answers.components(separatedBy: ",")
        self.choices.append(answer)
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.question = try container.decode(String.self, forKey: .question)
        self.answer = try container.decode(String.self, forKey: .answer)
        let wrong_answers = try container.decode(String.self, forKey: .wrong_answers)
        self.choices = wrong_answers.components(separatedBy: ",")
        self.choices.append(answer)
    }
}

var sampleQuestions: [question] = [
]
