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
    let cache = NSCache<NSString, NSArray>()
    
    static let shared = NetworkManager()
    
    func fetchData(fromRequest request: URLRequest, completion: @escaping (Data, Int, String) -> ()) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("error = \(error.debugDescription)")  // check for general errors
                return
            } else {
                
                guard let data = data, let httpStatus = response as? HTTPURLResponse else { return }
                
                let responseString = String(data: data, encoding: .utf8)!
                
//                print("response = \(String(describing: response))")
                
                completion(data, httpStatus.statusCode, responseString)
            }
            }.resume()
    }
    
    //    MARK: - Auth METHODS
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
    
    //    MARK: - GET METHODS
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
                    var tasksIds: [Int] = []
                    for task in tasksList {
                        tasksIds.append(Int(task.id)!)
                    }
                    self.getTask(byIds: tasksIds, completion: { tasks in
                            completion(tasks)
                    })
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
    }
    
    func getTask(byIds ids: [Int], completion: @escaping ([Task]) -> ()) {
        guard let accessToken = accessToken else { return }
        let stringIds = ids.map{ String($0) }.joined(separator: ",")
        let url = URL(string: "http://webtst:7878/api/ems/issues/\(stringIds)?include=extra,project")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(String(describing: accessToken))", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                do {
                    var tasks: [Task] = []
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let APItasks = try decoder.decode([APITask].self, from: data)
                    for APItask in APItasks {
                        var task = Task.init(id: Int(APItask.id)!,
                                             subject: APItask.base.subject,
                                             type: TaskType.Name.init(rawValue: APItask.base.typeName)!,
                                             state: TaskState(taskType: TaskType.Name.init(rawValue: APItask.base.typeName)!, name: APItask.base.stateName),
                                             assignee: APItask.base.assigneeName,
                                             author: APItask.base.authorName,
                                             priority: APItask.base.priority,
                                             supplyPlanDate: nil,
                                             description: APItask.extra.desc.trimmingCharacters(in: .whitespacesAndNewlines),
                                             projectName: APItask.project.name,
                                             projectManager: APItask.project.managerName,
                                             projectClient: APItask.project.clientName,
                                             projectStage: APItask.project.stageName)
                        if task.type == .nse {
                            task.supplyPlanDate = APItask.extra.supplyPlanDate
                        }
                        if task.state == nil {
                            print("Для задачи \(task.id) не найдено соответствие состоянию \(APItask.base.stateName)")
                        }
                        tasks.append(task)
                    }
                    completion(tasks)
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
    }
    
    func getTaskTransitions(_ taskId: Int, completion: @escaping ([TaskState]) -> ()) {
        guard let accessToken = accessToken else { return }
        let url = URL(string: "http://webtst:7878/api/ems/issues/\(taskId)/transitions")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(String(describing: accessToken))", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                do {
                    var taskStates: [TaskState] = []
                    let transitions = try JSONDecoder().decode([APITransition].self, from: data)
                    for transition in transitions {
                        let taskState = TaskState(taskStateId: transition.targetstate.id)
                        if let taskState = taskState {
                            taskStates.append(taskState)
                        } else {
                            print(print("Для задачи \(taskId) не найдено соответствие возможному состоянию с ID = \(transition.targetstate.id)"))
                        }
                    }
                    completion(taskStates)
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
        
    }
    
    func getWorklogTypes(completion: @escaping ([WorklogType]) -> ()) {
        let url = URL(string: "http://webtst:7878/api/ems/meta/model/contracts/worklog/type")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                do {
                    var worklogTypes: [WorklogType] = []
                    let APIworklogTypes = try JSONDecoder().decode(APIWorklogTypes.self, from: data)
                    
                    for member in APIworklogTypes.members {
                        var worklogType = WorklogType(id: member.value, name: member.name, isOften: false)
                        if member.name.oneOf(other: "Анализ", "Визирование", "Планирование", "Разработка", "Тестирование") {
                            worklogType.isOften = true
                        }
                        worklogTypes.append(worklogType)
                    }
                    completion(worklogTypes)
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
    }
    
    func getEmployees(completion: @escaping ([Employee]) -> ()) {
        let url = URL(string: "http://webtst:7878/api/ems/employees/status/2")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                do {
                    var employees: [Employee] = []
                    let apiEmployees = try JSONDecoder().decode([APIEmployee].self, from: data)
                    for apiEmployee in apiEmployees {
                        if !(apiEmployee.flags.isTech || apiEmployee.flags.doNotShowInPhonebook) {
                            let employee = Employee(id: apiEmployee.id,
                                                    headId: apiEmployee.headId,
                                                    lastName: apiEmployee.lastName,
                                                    firstName: apiEmployee.firstName,
                                                    middleName: apiEmployee.middleName,
                                                    fullName: apiEmployee.fullName,
                                                    brief: apiEmployee.brief,
                                                    headFullName: apiEmployee.headFullName,
                                                    branch: apiEmployee.branch,
                                                    email: apiEmployee.email,
                                                    skype: apiEmployee.skype,
                                                    room: apiEmployee.room,
                                                    phone: apiEmployee.phone,
                                                    mobile: apiEmployee.mobile,
                                                    position: apiEmployee.position,
                                                    topDepartmentId: apiEmployee.topDepartmentId,
                                                    topDepartment: apiEmployee.topDepartment,
                                                    department: apiEmployee.department,
                                                    departmentId: apiEmployee.departmentId)
                            employees.append(employee)
                        }
                    }
                    completion(employees)
                } catch let error {
                    print("Error serialization json: ", error)
                }
            } else {
                print(responseString)
            }
        }
    }
    
    func getData(forKey key: String, completion: @escaping ([CachableProtocol]) -> ()) {
        if  key == "workLogTypes" {
            getWorklogTypes { objects in
                self.cache.setObject(objects as NSArray, forKey: key as NSString)
                completion(objects)
            }
        }
        if key == "tasks"{
            getTasksForCurrentUser { objects in
                self.cache.setObject(objects as NSArray, forKey: key as NSString)
                completion(objects)
            }
        }
        if key.hasPrefix("taskStates") {
            let components = key.components(separatedBy: "+")
            let taskId = Int(components[1])!
            getTaskTransitions(taskId) { objects in
                self.cache.setObject(objects as NSArray, forKey: key as NSString)
                completion(objects)
            }
        }
        if key == "employees" {
            getEmployees { objects in
                self.cache.setObject(objects as NSArray, forKey: key as NSString)
                completion(objects)
            }
        }
    }
    
    //    MARK: - POST METHODS
    func postWorklog(task: String, time: String, type: Int, date: String, completion: @escaping (Bool, String) -> ()) {
        guard let accessToken = accessToken else { return }
        let url = URL(string: "http://webtst:7878/api/ems/worklog/context/add")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters = ["issue_id": task, "time_spent": time, "type_of_work": type, "date": date] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            completion(false, error.localizedDescription)
        }
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                do {
                    let apiSuccessResponse = try JSONDecoder().decode(APISuccessResponse.self, from: data)
                    let success = apiSuccessResponse.success
                    let details = apiSuccessResponse.details
                    completion(success, details)
                } catch let error {
                    completion(false, "Error serialization json: \(error.localizedDescription)")
                }
            } else {
                completion(false, "statusCode = \(statusCode): \n \(responseString)")
            }
        }
    }
    
    //    MARK: - PUT METHODS
    func putTaskTransition(taskId: Int, from: Int, to: Int, completion: @escaping (Bool, String) -> ()) {
        guard let accessToken = accessToken else { return }
        let url = URL(string: "http://webtst:7878/api/ems/issues/context/\(taskId)/transfer")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let parameters = ["username": "",
                          "state_source": "",
                          "from": from,
                          "to": to,
                          "assigned": "adelin@diasoft.ru",
                          "notes": "",
                          "worklog": ["time_spent": "00:01",
                                      "type_of_work": 1],
                          "categorization": ["type": 1,
                                             "author": "adelin@diasoft.ru",
                                             "reason": "---",
                                             "prevention": "---"],
                          "readme": ["impact_analysis_code": ["off": true],
                                     "impact_analysis": ["off": true],
                                     "description": ["off": true]],
                          "solution": "---",
                          "error_type": 6,
                          "reason_rejection": 21] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            completion(false, error.localizedDescription)
        }
        
        fetchData(fromRequest: request) { data, statusCode, responseString in
            if statusCode == 200 {
                do {
                    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    let success = apiResponse.result.success
                    let details = apiResponse.result.details
                    completion(success, details)
                } catch let error {
                    completion(false, "Error serialization json: \(error.localizedDescription)")
                }
            } else {
                completion(false, "statusCode = \(statusCode): \n \(responseString)")
            }
        }
    }
}
