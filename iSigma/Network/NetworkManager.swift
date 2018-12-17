//
//  NetworkManager.swift
//  iSigma
//
//  Created by Alex Delin on 14/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private let appName = "adelin@TestApp"
    private let clientSecret = "03408b403cd98bdd785736a52453bd3e"
    var accessToken: String?
    var refreshToken: String?
    
    static let shared = NetworkManager()
    
    func fetchData(fromRequest request: URLRequest, completion: @escaping (Data, Int, String) -> ()) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("error = \(error.debugDescription)")  // check for general errors
                return
            } else {
                
                guard let data = data, let httpStatus = response as? HTTPURLResponse else { return }
                
                let responseString = String(data: data, encoding: .utf8)
                
                print("response = \(String(describing: response))")
                
                completion(data, httpStatus.statusCode, String(describing: responseString))
            }
            }.resume()
    }
    
    func auth(withUser user: String, completion: @escaping () -> ()) {
        let url = URL(string: "http://webtst:7878/api/ems/auth/hash")!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "client_id=\(appName)&username=\(user)"
        request.httpBody = postString.data(using: .utf8)
        
        fetchData(fromRequest: request) { (data, statusCode, responseString) in
            if statusCode == 200 {
                do {
                    let authHash = try JSONDecoder().decode(APIAuthHash.self, from: data)
                    let hash = authHash.hash
                    print("hash = \(hash)")
                    self.authToken(withHash: hash, completion: { accessToken, refreshToken in
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        print("accessToken: \(String(describing: self.accessToken))")
                        print("refreshToken: \(String(describing: self.refreshToken))")
                        completion()
                    })
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else if statusCode == 401 {
                print("Вам отправлено письмо с запросом на подтверждение выполнение операций в EMS. Проверьте свой почтовый ящик!")
            } else {
                print(responseString)
            }
        }
    }
    
    func authToken(withHash hash: String, completion: @escaping (String, String) -> ()) {
        let url = URL(string: "http://webtst:7878/api/ems/auth/token")!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "client_id=\(appName)&client_secret=\(clientSecret)&grant_type=hash&hash=\(hash)"
        request.httpBody = postString.data(using: .utf8)
        
        fetchData(fromRequest: request) { (data, statusCode, responseString) in
            if statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let authToken = try decoder.decode(APIAuthToken.self, from: data)
                    let accessToken = authToken.accessToken
                    let refreshToken = authToken.refreshToken
                    completion(accessToken, refreshToken)
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
    }
    
    func getTasksForCurrentUser(completion: @escaping ([Task]) -> ()) {
        guard let accessToken = accessToken else { return }
        let url = URL(string: "http://webtst:7878/api/ems/issues/context/assigned")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                print("TASKS: \(String(describing: responseString))")
                do {
                    let tasksList = try JSONDecoder().decode([APITaskID].self, from: data)
                    var tasks: [Task] = []
                    for task in tasksList {
                        let taskId = Int(task.id)!
                        self.getTask(byId: taskId, completion: { task in
                            tasks.append(task)
                            if tasksList.count == tasks.count {
                                completion(tasks)
                            }
                        })
                    }
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
    }
    
    func getTask(byId id: Int, completion: @escaping (Task) -> ()) {
        guard let accessToken = accessToken else { return }
        let url = URL(string: "http://webtst:7878/api/ems/issues/\(String(id))?include=extra,project")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(String(describing: accessToken))", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                do {
                    let APItasks = try JSONDecoder().decode([APITask].self, from: data)
                    for task in APItasks {
                        let task = Task.init(id: Int(task.id)!,
                                             subject: task.base.subject,
                                             type: task.base.typeName,
                                             state: task.base.stateName,
                                             assignee: task.base.assigneeName,
                                             author: task.base.authorName,
                                             priority: task.base.priority)
                        completion(task)
                    }
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
    }
    
}
