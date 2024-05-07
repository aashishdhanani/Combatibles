//
//  DataModel.swift
//  combatible
//
//  Created by Aiden Seibel on 4/19/24.
//

import Foundation
import UIKit

class DataModel: ObservableObject {
    static func getAllUsers() {
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/user/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            print(response ?? "no response")
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }

            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                } else {
                    print("Unable to convert data to string.")
                }
            }
            
        }.resume()
    }
    
    static func getUser(userID: Int, completion: @escaping (user?) -> Void) {
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/user/\(userID)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            print(response ?? "no response")
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                    do {
                        let decoder = JSONDecoder()
                        let this_user = try decoder.decode(user.self, from: Data(responseString.utf8))
                        completion(this_user)
                    } catch {
                        print("Error decoding user: \(error)")
                    }
                } else {
                    print("Unable to convert data to string.")
                }
            }
        }.resume()
        
        completion(nil)
    }
    
    static func getQuestion(questionID: Int) {
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/question/\(questionID)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            print(response ?? "no response")
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                } else {
                    print("Unable to convert data to string.")
                }
            }
        }.resume()
    }

    static func getBattle(battleID: Int) {
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/battle/\(battleID)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            print(response ?? "no response")
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                } else {
                    print("Unable to convert data to string.")
                }
            }
        }.resume()
    }
    
    static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Unable to create image from data.")
                completion(nil)
            }
        }.resume()
    }
    
    static func signInUser(username: String, password: String, completion: @escaping (user?, String) -> Void) {
        print("Signing in user...")
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/user/token") else {
            print("Invalid URL")
            completion(nil, "")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = ["username": username, "password": password]
                
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                print(response ?? "no response")
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Server error in signing in user")
                    return
                }
                
                // if we get a response
                if let data = data {
                    do{
                        // try to convert to dictionary
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dict = json as? [String: Any] {
                            print(dict)
                            if let userID = dict["uid"] as? Int, let authToken: String = dict["token"] as? String{
                                print("Response received for login. Getting user...")
                                getUser(userID: userID){ local_user in
                                    print("Successfully got user.")
                                    completion(local_user, authToken)
                                }
                            }
                        } else {
                            print("JSON is invalid")
                        }
                    }catch{
                        print("Something went wrong..")
                    }
                }
            }.resume()
        } catch {
            print("Error encoding JSON while signing in user: \(error)")
        }
        completion(nil, "")
    }
    
    
    static func signUpUser(username: String, email: String, password: String, dob_string: String, location: String, firstName: String, completion: @escaping (user?, String) -> Void) {
        print("Signing up user...")
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/user/create") else {
            print("Invalid URL")
            completion(nil, "")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = ["username": username, "email": email, "password": password, "date_of_birth": dob_string, "location": location, "first_name": firstName]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                print(response ?? "no response")
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Server error in signing up user")
                    return
                }
                
                if let data = data {
                    do{
                        // try to convert to dictionary
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dict = json as? [String: Any] {
                            print(dict)
                            if let userID = dict["user_id"] as? Int, let authToken: String = dict["token"] as? String{
                                print("Response received for signup. Getting user...")
                                getUser(userID: userID){ local_user in
                                    print("Successfully got user.")
                                    completion(local_user, authToken)
                                }
                            }else{
                                print("could not get userID from json dict when signing in user")
                            }
                        } else {
                            print("JSON is invalid")
                        }
                    }catch{
                        print("Something went wrong..")
                    }
                }
            }.resume()
        } catch {
            print("Error encoding JSON while signing up user: \(error)")
        }

        completion(nil, "")
    }
    
    static func updateUserInfo(authToken: String, args: [String: String]){
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/user/profileupdate") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        let parameters: [String: Any] = args
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                print(response ?? "no response")
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Server error in updating user profile")
                    return
                }
                
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print(responseString)
                    } else {
                        print("Unable to convert data to string.")
                    }
                }
            }.resume()
        } catch {
            print("Error encoding JSON while updating user profile: \(error)")
        }
    }
    
    
    static func rizz(authToken: String, interests: String, bio: String, movie: String){
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/user/rizz") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        let parameters: [String: Any] = ["interests":interests, "bio": bio, "favorite_movie": movie]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                print(response ?? "no response while rizzing user")
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Server error in rizzing user")
                    return
                }
                
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print(responseString)
                    } else {
                        print("Unable to convert data to string while rizzing.")
                    }
                }
            }.resume()
        } catch {
            print("Error encoding JSON while rizzing user: \(error)")
        }
    }
    
    static func fetchRandomQuestions(authToken: String, uid: Int, number_of_questions: Int, completion: @escaping ([question]) -> Void) {
        guard let url = URL(string: "https://swinger-test.azurewebsites.net/api/question/user-retrieve-random-questions") else {
            print("Invalid URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        print(uid)
        let parameters: [String: Int] = ["uid": uid, "number_of_questions": number_of_questions]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            print(request)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                print(response ?? "no response in fetching questions")
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Server error in fetching questions")
                    return
                }
                
                if let data = data {
                    do{
                        // try to convert to dictionary
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dict = json as? [[String: Any]] {
                            print(dict)
                            var questions: [question] = []
                            for q in dict{
                                if let id = q["id"] as? Int, let userID = q["created_by"] as? Int, let question_content = q["question_content"] as? String, let answer = q["answer"] as? String, let wrong_answers = q["wrong_answers"] as? String{
                                    questions.append(question(id: id, userID: userID, question: question_content, wrong_answers: wrong_answers, answer: answer))
                                }
                            }
                            
                            completion(questions)
                        } else {
                            print("failed parsing json as array of dictionaries")
                        }
                    }catch{
                        print("Something went wrong..")
                    }
                }

            }.resume()
        } catch {
            print("Error encoding JSON while fetching questions: \(error)")
        }
        completion([])
    }
}
