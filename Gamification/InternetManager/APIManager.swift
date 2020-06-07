//
//  APIManager.swift
//  Gamification
//
//  Created by Nurbek on 4/26/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import Alamofire

class APIManager {
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE0MjAyNTUwYmY4ZWYxNjViNGM5YWUxYTI1MWY3NTFjMzQ3OWFmMWI3M2ZkYWQ2MzI4OWEwYzdjNDEzYjJkN2U3NGVmOWIyMzFlMDYwOTNkIn0.eyJhdWQiOiIxIiwianRpIjoiYTQyMDI1NTBiZjhlZjE2NWI0YzlhZTFhMjUxZjc1MWMzNDc5YWYxYjczZmRhZDYzMjg5YTBjN2M0MTNiMmQ3ZTc0ZWY5YjIzMWUwNjA5M2QiLCJpYXQiOjE1ODc2NjE0NzYsIm5iZiI6MTU4NzY2MTQ3NiwiZXhwIjoxNjE5MTk3NDc2LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.iK1Eg8iy_WcXSfV3toFI7WWA8pJz2LVn7JLxfgrOyrzS4__EfCT9Rr0sCIbU17SsSrpfDYHbGdzaDcdcrimhgf4leecdccNbZIDyxfFqlmWK7d4lrGMRMz7aLwbLtqf0-mafD8gfyIarcmT9E5X9I45VqkqBhjJXpPZYxdQ5ENR25NiOLJUxBoJJfsIu7E_E0_cC-htgTmJl96mohZlVr4MGraE_fktF8PaclFJeUby8rNLtgjvv_bLxxbJh-fea5wA36BikVHC4lOtWv-tFIdQOUpD5dXSRw1JxsXYEYBG3NlpoylwavGGc8verKa4Vk5AtXPcd0lTf0TTXcrmMdSWYHMzoo1iV-39a2c1RJvMTHWrWRmNz6iTbNUEu8TD0E3Z2H_-fEdv4XBoFMlPKQD5nOh6WNjS6hLaNynxbKKkXEnUUDtMim3MKruchRBYE5gKZI92WmZWgas-HklqIY3WywnWxqEPWV0bORRxiaCJrroK7ywzAP6liTKRjnJ2rMlgwBzDheGZ7HpfRKxbHez6TDFvYh7vXhV2mp8-te_dbhBq0hsxtUM2Y3NrzRnS4Wf-r7srHpnLQAQRHVBRCjvoLhOnDiX4-q9ySpEZKu2r-Wi5J6MBImnr-ZxdxPAlOZVPt4Vl9gohU5gmB6eixSfn3-30ev3WA0adhA-VmgTo",
        "Accept": "application/json"
    ]
    var allTasks: [task]?
    var allTasksWithIsDone: [task : Bool]!
    var allChallenges: [challenge]?
    
    func getAllTasks() -> [task]{
        
        AF.request("http://daily.prosthesis.kz/api/v1/daily/1", headers: headers).responseJSON { response in
            do {
                switch response.result {
                case .success:
                    let jsonData = response.data
                    self.allTasks = try JSONDecoder().decode([task].self, from: jsonData!)
                    for task in self.allTasks! {
                        self.allTasksWithIsDone[task] = false
                    }
                    
                case .failure(_):
                    print("fail")
                }
                
            }catch {
                print("JSONSerialization error:", error)
            }
            
        }
        return allTasks!
    }
    func getAllChallenges() -> [challenge] {
        
        AF.request("http://daily.prosthesis.kz/api/v1/challenges", headers: headers).responseJSON { response in
            do {
                switch response.result {
                    
                case .success:
                    let jsonData = response.data
                    self.allChallenges = try JSONDecoder().decode([challenge].self, from: jsonData!)
                    
                case .failure(_):
                    print("fail")
                    
                }
            }catch {
                print("JSONSerialization error:", error)
            }
        }
        return allChallenges!
    }
}
