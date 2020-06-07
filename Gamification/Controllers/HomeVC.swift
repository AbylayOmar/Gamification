//
//  homeVC.swift
//  Gamification
//
//  Created by Nurbek on 3/10/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var paryzView: UIView!
    @IBOutlet weak var sunnetView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //var toDoListForToday = [ToDoModel.init(toDo: "Видео қарау", isDone: false, hasLink: true, link: "https://www.youtube.com/watch?v=H5bEUc72TuE"), ToDoModel.init(toDo: "Ораза", isDone: true, hasLink: false, link: ""), ToDoModel.init(toDo: "Кәлимә таухид 100 рет", isDone: false, hasLink: true, link: "https://www.google.com/")]
    var namazdar = ["tangP", "besinP", "ekintiP", "shamP", "quptanP","utir", "tangS", "besinS", "shamS", "ekintiS", "quptanS"]
    
    var resultTasks: [NSManagedObject]?
    var resultNamazes: [NSManagedObject]?
    var taskEntity: NSEntityDescription!
    var namazEntity: NSEntityDescription!
    var managedContext: NSManagedObjectContext!
    
    
    var allTasksWithIsDone: [task : Bool]?
    
    override func viewDidLoad() {
        //SVProgressHUD.show()
        super.viewDidLoad()
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        print(deviceID)
        // Do any additional setup after loading the view.
        configureView()
        manageContext()
        retrieveData()
        configureButtons()
        //retrieveDataNamazes()
        
        //SVProgressHUD.setOffsetFromCenter(.init(horizontal: UIScreen.main.bounds.width/2, vertical: UIScreen.main.bounds.height/2))
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if traitCollection.userInterfaceStyle == .light {
    //            print("Light mode")
    //        } else {
    //            print("Dark mode")
    //        }
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultTasks != nil {
            return resultTasks!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDo") as? ToDoTableViewCell
        cell?.object = resultTasks![indexPath.row]
        cell?.managedContext = managedContext
        cell?.whatToDoLabel.text = resultTasks![indexPath.row].value(forKey: "name") as? String
        let link = resultTasks![indexPath.row].value(forKey: "link") as? String
        cell?.hasLink = (link != nil)
        
        if (resultTasks![indexPath.row].value(forKey: "isDone") as? Bool)! {
            cell?.isDoneButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else {
            cell?.isDoneButton.backgroundColor = .white
        }
        
        
        cell?.isDoneButton.layer.cornerRadius = 12.5
        cell?.isDoneButton.layer.shadowRadius = 5
        cell?.isDoneButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell?.isDoneButton.layer.shadowOpacity = 0.7
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let link = self.resultTasks![indexPath.row].value(forKey: "link") as? String
            if (link != nil) {
                let webViewController = self.storyboard!.instantiateViewController(withIdentifier: "webVC") as! WebViewController
                webViewController.header = self.resultTasks![indexPath.row].value(forKey: "name") as? String
                webViewController.link = self.resultTasks![indexPath.row].value(forKey: "link") as? String
                
                self.present(webViewController, animated: true, completion: nil)
                self.tableView.cellForRow(at: indexPath)?.isSelected = false
            }
        }
    }
    
    func configureView() {
        self.tabBarItem.image = UIImage(named: "home-1")
        
        TopView.backgroundColor = TopView.backgroundColor!.withAlphaComponent(0.4)
        TopView.layer.cornerRadius = 20
        BottomView.backgroundColor = BottomView.backgroundColor!.withAlphaComponent(0.4)
        BottomView.layer.cornerRadius = 20
        
        paryzView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        
        
        paryzView.centerYAnchor.constraint(equalTo: buttons[0].centerYAnchor).isActive = true
        paryzView.centerXAnchor.constraint(equalTo: TopView.rightAnchor, constant: -(screenWidth-280)/10-50).isActive = true
        
        sunnetView.translatesAutoresizingMaskIntoConstraints = false
        sunnetView.centerYAnchor.constraint(equalTo: buttons[10].centerYAnchor).isActive = true
        sunnetView.centerXAnchor.constraint(equalTo: TopView.rightAnchor, constant: (-(screenWidth-275)*3)/8-105).isActive = true
        
        for button in buttons {
            button.layer.cornerRadius = 12.5
            
            button.layer.shadowRadius = 5
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 0.7
        }
        
        
        
        
    }
    
    func configureButtons() {
        for (index,button) in buttons.enumerated() {
            for namaz in resultNamazes! {
                if (namaz.value(forKey: "id") as! Int) == index {
                    if namaz.value(forKey: "isDone") as! Bool {
                        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    }
                    else {
                        button.backgroundColor = .white
                    }
                    break
                }
            }
        }
    }
    
    @IBAction func topViewButtondClicked(_ sender: UIButton) {
        for (index, i) in buttons.enumerated() {
            if i==sender {
                if sender.backgroundColor == UIColor.white {
                    sender.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    print(namazdar[index]+" done")
                    print(index)
                    do {
                        for namaz in resultNamazes! {
                            if (namaz.value(forKey: "id") as! Int) == index {
                                print(namaz.value(forKey: "name"))
                                print("name")
                                namaz.setValue(true, forKey: "isDone")
                                break
                            }
                        }
                        do {
                            try managedContext.save()
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                }
                else {
                    sender.backgroundColor = .white
                    print(namazdar[index]+" in process")
                    do {
                        for namaz in resultNamazes! {
                            if (namaz.value(forKey: "id") as! Int) == index {
                                print(namaz.value(forKey: "name"))
                                print("name")
                                namaz.setValue(false, forKey: "isDone")
                                break
                            }
                        }
                        do {
                            try managedContext.save()
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
        }
    }
    
    func manageContext() {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        managedContext = appDelegate.persistentContainer.viewContext
        //Now let’s create an entity and new user records.
        taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        namazEntity = NSEntityDescription.entity(forEntityName: "Namaz", in: managedContext)!
    }
    func retrieveData() {
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequestTasks = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let fetchRequestNamazes = NSFetchRequest<NSFetchRequestResult>(entityName: "Namaz")
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            resultTasks = try managedContext.fetch(fetchRequestTasks) as? [NSManagedObject]
            resultNamazes = try managedContext.fetch(fetchRequestNamazes) as? [NSManagedObject]
            print(resultTasks?.count,"hey")
            for data in resultTasks! {
                print(data.value(forKey: "id") as? Any)
                print(data.value(forKey: "name") as? Any)
                print(data.value(forKey: "link") as? Any)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //        print("any")
    //        if let navbar = segue.destination as? UINavigationController{
    //            if let destination = navbar.visibleViewController as? WebViewController {
    //                let index = (tableView.indexPathForSelectedRow?.row)!
    //                print(index)
    //                destination.link = toDoListForToday[index].link
    //                destination.header = toDoListForToday[index].toDo
    //            }
    //        }
    //    }
    
    
}
