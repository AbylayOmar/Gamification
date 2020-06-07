//
//  LaunchViewController.swift
//  Gamification
//
//  Created by Nurbek on 5/2/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

@available(iOS 13.0, *)
class LaunchViewController: UIViewController {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjA1ZGE0NzJiYTE2NjM1ODQ3NDQxZGM5YjIyMjI5MjBiMDc3Zjk4ZWY1OWUxNzMzODI4ZmZhNzdjZDg3NjViZThmZjU3YzgxYjRlMDM5OGIyIn0.eyJhdWQiOiIxIiwianRpIjoiMDVkYTQ3MmJhMTY2MzU4NDc0NDFkYzliMjIyMjkyMGIwNzdmOThlZjU5ZTE3MzM4MjhmZmE3N2NkODc2NWJlOGZmNTdjODFiNGUwMzk4YjIiLCJpYXQiOjE1ODg5Mjc4MTMsIm5iZiI6MTU4ODkyNzgxMywiZXhwIjoxNjIwNDYzODEzLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.qiFZya1_BhU6gH9KCiT61tfnnO7A3pfUGDmJzsLUQsUClws02yO2yPABgkBo7EKtzSGvA6RLrbi2tS8OvSiZ490AoVeuTGVaCKnEAyBaWtSTVt0Ub4_PyZoC5vigsYJm-Z_AoIU0Ttb0-ZHEbNRJQICJX4bdF9dikzlEY_46q13MzeLztNxxaMiUwjtqoHTbnJIOSDjV9ZBIq3FFYyiUV0c4PG26L9xAfaj1-6BgjRuehH431X1PiLZ6W0pc4XRbitWcHJ-Ood0vSZQJ9Ccp2Lp2ie9j_qQ2cNzSzAVFP6FzblXLW3D9Zb2PLuy7MbokSb8VmL8ur816nach6kdIhdZbQo7JQV7XH-troqdD2joGhxTNHVY92lZ4TA3PyHIQA9A7e_VRkPGsJxBywH6BAH_aw7InRs0UozcA4Ydtv7dz4CsgqJB_Q8_rhy0_JSR4Eh_v0YiYzQ7i0X4JLXC6NO0tH3nmk1kAb35NqODrZDDn5NTNHTswMHjYydjOlQ5ybRI122B4iKxBNRtDhUqdCOo_IiyVXbk5tjiibP7-LveFJQoubp3OISA21Fwf9fq2LNEvBk1e8u2x7nftJdajFAZvIgYEyxcOyHSBacPZES_oBSv60Y4GYktrJV_0SxnThzB32TEX_zPDE652zeemh2C2tYjceVeNvVmjNQi7AH0",
        "Accept": "application/json"
    ]
    var namazes = [namaz(id: 0, name: "Таң парызы", isDone: false), namaz(id: 1, name: "Бесін парызы", isDone: false), namaz(id: 2, name: "Екінті парызы", isDone: false), namaz(id: 3, name: "Ақшам парызы", isDone: false), namaz(id: 4, name: "Құптан парызы", isDone: false), namaz(id: 5, name: "Утір", isDone: false), namaz(id: 6, name: "Таң сүннеті", isDone: false), namaz(id: 7, name: "Бесін сүннеті", isDone: false), namaz(id: 8, name: "Ақшам сүннеті", isDone: false), namaz(id: 9, name: "Екінті сүннеті*", isDone: false), namaz(id: 10, name: "Құптан сүннеті*", isDone: false)]
    @IBOutlet weak var containerView: UIView!
    var timer: Timer!
    var timeTotal = 200
    var timeRemaining = 200
    //TimeZone(secondsFromGMT: 3600*5)!
    var currentDate: Date = Calendar.current.dateComponents(in: .current, from: Date()).date!
    //Calendar.current.dateComponents(in: .current, from: Date()).date!
    var taskEntity: NSEntityDescription!
    var namazEntity: NSEntityDescription!
    var userEntity: NSEntityDescription!
    var challengeEntity: NSEntityDescription!
    var managedContext: NSManagedObjectContext!
    var hasPassedDeadline = false
    
    @IBOutlet weak var bottomConstaintContainerView: NSLayoutConstraint!
    var userData: user! {
        didSet {
            DispatchQueue.main.async {
                self.createUserData()
            }
        }
    }
    var allChalenges: [challenge]! {
        didSet {
            DispatchQueue.main.async {
                self.createChallengeData()
            }
        }
    }
    var allTasks: [task]! {
        didSet {
            DispatchQueue.main.async {
                self.configureTimer()
                self.checkData()
            }
        }
    }
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - there u can change the date by urself just delete the comments
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        currentDate = formatter.date(from: "2020/05/22 00:59")!
        
        progressView.setProgress(1, animated: false)

        
        manageContext()
        deleteUserAndChallengeData()
        getInformations()
    }
    func configureTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.timerRunning), userInfo: nil, repeats: true)
    }
    func checkData() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        // check the date
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let date = data.value(forKey: "date") as! Date
                if !Calendar.current.isDate(currentDate, equalTo: date, toGranularity: .day) {
                    self.hasPassedDeadline = true
                }
            }
            
            if result.isEmpty || hasPassedDeadline{
                self.createTaskData()
            }
        } catch {
            print("Failed")
        }
    }
    
    func manageContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
        taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        namazEntity = NSEntityDescription.entity(forEntityName: "Namaz", in: managedContext)!
        userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        challengeEntity = NSEntityDescription.entity(forEntityName: "Challenge", in: managedContext)!
    }
    
    func getInformations() {
        // challenges
        AF.request("http://daily.prosthesis.kz/api/v1/challenges", headers: headers).responseJSON { response in
            do {
                switch response.result {
                case .success:
                    let jsonData = response.data
                    debugPrint(response)
                    self.allChalenges = try JSONDecoder().decode([challenge].self, from: jsonData!)
                case .failure(_):
                    print("fail")
                }
                
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        //user data for now statistic
        AF.request("http://daily.prosthesis.kz/api/v1/statistic", headers: headers).responseJSON { response in
            do {
                switch response.result {
                case .success:
                    let jsonData = response.data
                    debugPrint(response)
                    self.userData = try JSONDecoder().decode(user.self, from: jsonData!)
                case .failure(_):
                    print("fail")
                }
                
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        //tasks
        AF.request("http://daily.prosthesis.kz/api/v1/daily/1", headers: headers).responseJSON { response in
            do {
                switch response.result {
                case .success:
                    let jsonData = response.data
                    debugPrint(response)
                    self.allTasks = try JSONDecoder().decode([task].self, from: jsonData!)
                case .failure(_):
                    self.alert(message: "Сіздің девайсыңыз интернетке қосылмаған!")
                    print("fail")
                }
                
            } catch {
                print("JSONSerialization error:", error)
            }
        }

    }
    func alert(message: String) {
        let alert = UIAlertController(title: "Дабыл", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ок", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func timerRunning(){
        if timeRemaining == 0 {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
            do {
                let a = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                print(a![0].value(forKeyPath: "percent"),"%%%")
            } catch {
                print("there's no user")
            }
             
            
            //
            
            
            let vc = self.storyboard?.instantiateViewController(identifier: "tabBarVC") as! TabBarController
            vc.modalTransitionStyle = .crossDissolve
            if hasPassedDeadline {
                self.bottomConstaintContainerView.isActive = false
                UIView.animate(withDuration: 1.0) {
                    self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                    self.view.layoutIfNeeded()
                }
            }
            else {
                self.present(vc, animated: true, completion: nil)
            }
        }
        timeRemaining -= 1
        progressView.setProgress(Float(timeRemaining)/Float(timeTotal), animated: true)
    }
    func deleteUserAndChallengeData() {
        let fetchRequestChallenge: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Challenge")
        let fetchRequestUser: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let deleteRequestChallenge = NSBatchDeleteRequest(fetchRequest: fetchRequestChallenge)
        let deleteRequestUser = NSBatchDeleteRequest(fetchRequest: fetchRequestUser)
        
        do {
            try managedContext.execute(deleteRequestChallenge)
            try managedContext.execute(deleteRequestUser)
            try managedContext.save()
        }
        catch _ as NSError {
            // Handle error
        }
    }
    // appends new user's data and challenges to CoreData
    func createChallengeData() {
        
        for i in allChalenges {
            let challenge = NSManagedObject(entity: challengeEntity, insertInto: managedContext)
            challenge.setValue(i.id, forKey: "id")
            challenge.setValue(i.name, forKey: "name")
            challenge.setValue(i.price, forKey: "price")
            challenge.setValue(i.state, forKey: "state")
            challenge.setValue(i.image_url, forKey: "image_url")
            challenge.setValue(i.url, forKey: "url")
        }
        
        do {
            try managedContext.save()
           print("saved!!!!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func createUserData() {
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(userData.percent, forKey: "percent")
        user.setValue(userData.finished, forKey: "finished")
        user.setValue(userData.all, forKey: "all")
        
        do {
            try managedContext.save()
           print("saved!!!!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // appends new tasks to CoreData
    func createTaskData() {
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        
        
//        //some code for delete
//        let fetchRequestTask: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
//        let fetchRequestNamaz: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Namaz")
//        let deleteRequestTask = NSBatchDeleteRequest(fetchRequest: fetchRequestTask)
//        let deleteRequestNamaz = NSBatchDeleteRequest(fetchRequest: fetchRequestNamaz)
//        
//        do {
//            try managedContext.execute(deleteRequestTask)
//            try managedContext.execute(deleteRequestNamaz)
//            try managedContext.save()
//        }
//        catch _ as NSError {
//           // Handle error
//        }
//        
//        //end of some code
        
        
        print()
        print("date")
        
        for i in namazes {
            let namaz = NSManagedObject(entity: namazEntity, insertInto: managedContext)
            namaz.setValue(i.id, forKey: "id")
            namaz.setValue(i.name, forKey: "name")
            namaz.setValue(i.isDone, forKey: "isDone")
            namaz.setValue(currentDate, forKey: "date")
        }
        
        for i in allTasks! {
            let task = NSManagedObject(entity: taskEntity, insertInto: managedContext)
            task.setValue(i.id, forKeyPath: "id")
            task.setValue(i.name, forKeyPath: "name")
            task.setValue(i.link, forKeyPath: "link")
            task.setValue(currentDate, forKey: "date")
            task.setValue(false, forKeyPath: "isDone")
        }

        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "submit" {
                let vc = segue.destination as! SubmitTasksContainerViewController
                vc.arrayToDoIndices = arrayToDoIndices
                
            }
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
    */
}
