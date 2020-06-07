//
//  SubmitTasksContainerViewController.swift
//  Gamification
//
//  Created by Nurbek on 5/3/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SubmitTasksContainerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    var arrayToDoIndices: [NSManagedObject] = []
    var parameters: [postTasksModel] = []
    
    let currentDate = Calendar.current.dateComponents(in: .current, from: Date()).date!
    //var currentDate: Date!
    var taskEntity: NSEntityDescription!
    var managedContext: NSManagedObjectContext!
    var fetchRequestNamaz: NSFetchRequest<NSFetchRequestResult>!
    var fetchRequestTask: NSFetchRequest<NSFetchRequestResult>!
    
    var passedDate: Date = Date()
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6Ijc2M2FmZDU0NTJmOTYyMmU5OTNmM2U2M2JiMTY4ZWRjZGVlODc1MmY1YjQxYzM2YzJhNjEyZGZjMmI0MTk5YzA4YzMyYWRiNzA5ZmJhNjI0In0.eyJhdWQiOiIxIiwianRpIjoiNzYzYWZkNTQ1MmY5NjIyZTk5M2YzZTYzYmIxNjhlZGNkZWU4NzUyZjViNDFjMzZjMmE2MTJkZmMyYjQxOTljMDhjMzJhZGI3MDlmYmE2MjQiLCJpYXQiOjE1ODgzNjUwNjgsIm5iZiI6MTU4ODM2NTA2OCwiZXhwIjoxNjE5OTAxMDY4LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.NUS4SwiRECsi_rEGziLhQbhs84_xYflWxpRPfjnfQUis2DaiSmlr9gwLLijGmEvRsLzwPSNPGppqWYUUkztBu-jC6gWfZr6PGWLywZnaeZEWRwp-cSbHdElyjRJSKXx6Q5RwLo5znRzloP5OwjzaGjPsZ2kfwzdpZNXbYM1LpByC9U2f4gz_xZVXiC3thr5vwWw4_mTqh83FijT-CzF-jcjY3wIxz2Cn4MtAJx4voeyj5bQFtdIXz3vM5jNxL3sHYiiNMJxa-zVrV_48fFHf5BKEtBsyXlXCMR7J9P21uApXIIIaSaadJABFb4NjnquFYGo8IgLd7MQ3JBmmMfsRZTBB-uqH4hPWZGNSEjLWgftVKU7jySlnGDK3SixJ9ifh4x8B6sXXqwzpbv3pYanzfxgSLQYxURZ5XVf6ug9xk3cCatCRn67VZHVCFpudTHcsuGUHfv0evR8zQ5SP34jFco4JOOAY_F0l0oB8LSdX9f5eJeo1r4ezY0Bafi_Oui3CQHdyzGg81hT30nsTIJBOmn82kJtexxrjg6r-6yGlrUDq09dIVt3vIT4kgPZ3x2eCM9j0WlgH6Bx-Tv3-txeZpfyQaAN9ZuSVNitMKlV7enxdnc-IqKRlpqv29mDcPvlxYkmI8ic4VajUQjgQlR5qrehwbZCkUOvBdVk2h8bKWaA",
        "Accept": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - there u can change the date by urself just delete the comments
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        currentDate = formatter.date(from: "2020/05/22 00:59")!
        view.layer.cornerRadius = 20
        submitButton.layer.cornerRadius = 13.5
        manageContext()
        fillArray()
    }
    func manageContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
        taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
    }
    func fillArray() {
        
        fetchRequestNamaz = NSFetchRequest(entityName: "Namaz")
        fetchRequestTask = NSFetchRequest(entityName: "Task")
        // check the date
        do {
            let resultNamaz = try managedContext.fetch(fetchRequestNamaz)
            //print((result as! [NSManagedObject])[0].value(forKey: "date") as! Date)
            for data in resultNamaz as! [NSManagedObject] {
                let date = data.value(forKey: "date") as? Date
                print(currentDate.compare(date!).rawValue != 0)//below
                print("is it true namaz")
                if !Calendar.current.isDate(currentDate, equalTo: date!, toGranularity: .day) {
                    passedDate = date!
                    arrayToDoIndices.append(data)
                }
            }
            let resultTask = try managedContext.fetch(fetchRequestTask)
            //print((result as! [NSManagedObject])[0].value(forKey: "date") as! Date)
            for data in resultTask as! [NSManagedObject] {
                let date = data.value(forKey: "date") as? Date
                if !Calendar.current.isDate(currentDate, equalTo: date!, toGranularity: .day) {
                    passedDate = date!
                    arrayToDoIndices.append(data)
                }
            }
            
        } catch {
            
            print("Failed")
        }
        // configure title
        let dateFromStringFormatter = DateFormatter()
        dateFromStringFormatter.dateFormat = "dd.MM.YYYY"
        titleLabel.text = dateFromStringFormatter.string(from: passedDate) + " күнгі жасалғандар"
        
        // end
    }
    
    
    @available(iOS 13.0, *)
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        sumbitTasks()
        deleteData()
        let vc = self.storyboard?.instantiateViewController(identifier: "tabBarVC") as! TabBarController
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    func sumbitTasks() {
        let fetchRequestNamaz: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Namaz")
        let fetchRequestTask: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        // check the date
        do {
            let resultNamaz = try managedContext.fetch(fetchRequestNamaz)
            //print((result as! [NSManagedObject])[0].value(forKey: "date") as! Date)
            for data in resultNamaz as! [NSManagedObject] {
                let date = data.value(forKey: "date") as? Date
                print(currentDate.compare(date!).rawValue != 0)//below
                print("is it true namaz")
                if !Calendar.current.isDate(currentDate, equalTo:
                    date!, toGranularity: .day) {
                    parameters.append(postTasksModel(id: (data.value(forKey: "id")! as! Int), result: (data.value(forKey: "isDone")! as! Bool)))
                }
            }
            let resultTask = try managedContext.fetch(fetchRequestTask)
            //print((result as! [NSManagedObject])[0].value(forKey: "date") as! Date)
            for data in resultTask as! [NSManagedObject] {
                let date = data.value(forKey: "date") as? Date
                print(currentDate.compare(date!).rawValue != 0)//below
                print("is it true")
                if !Calendar.current.isDate(currentDate, equalTo: date!, toGranularity: .day) {
                    parameters.append(postTasksModel(id: (data.value(forKey: "id")! as! Int), result: (data.value(forKey: "isDone")! as! Bool)))
                }
            }
            print(parameters.count)
            AF.request("http://daily.prosthesis.kz/api/v1/results", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response(completionHandler: { (response) in
                debugPrint(response)
                do {
                    switch response.result {
                    case .success:
                        print("success")
                    case .failure(_):
                        print("fail")
                    }
                } catch {
                    print("JSONSerialization error:", error)
                }
                print("submited")
            })
            
        } catch {
            
            print("Failed")
        }
    }
    func deleteData() {
        do {
            let resultNamaz = try managedContext.fetch(fetchRequestNamaz)
            for data in resultNamaz as! [NSManagedObject] {
                let date = data.value(forKey: "date") as? Date
                if !Calendar.current.isDate(currentDate, equalTo: date!, toGranularity: .day) {
                    managedContext.delete(data)
                    debugPrint(data)
                }
            }
            let resultTask = try managedContext.fetch(fetchRequestTask)
            for data in resultTask as! [NSManagedObject] {
                let date = data.value(forKey: "date") as? Date
                if !Calendar.current.isDate(currentDate, equalTo: date!, toGranularity: .day) {
                    managedContext.delete(data)
                    debugPrint(data)
                }
            }
        } catch {
            print("Failed")
        }
        
        do {
          try managedContext.save()
        } catch {
          // Do something in response to error condition
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SubmitTasksContainerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayToDoIndices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoForSubmit") as! ToDoForSubmitTableViewCell
        cell.object = arrayToDoIndices[indexPath.row]
        cell.managedContext = managedContext
        cell.label.text = arrayToDoIndices[indexPath.row].value(forKey: "name") as? String
        if (arrayToDoIndices[indexPath.row].value(forKey: "isDone") as? Bool)! {
            cell.button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else {
            cell.button.backgroundColor = .white
        }
        cell.button.layer.cornerRadius = 12.5
        cell.button.layer.shadowRadius = 5
        cell.button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.button.layer.shadowOpacity = 0.7
        return cell
    }
    
    
}

