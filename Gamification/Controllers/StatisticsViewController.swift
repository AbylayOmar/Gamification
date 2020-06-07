//
//  StatisticViewController.swift
//  Gamification
//
//  Created by Nurbek on 3/24/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit
import CoreData

class StatisticsViewController: UIViewController {

    @IBOutlet weak var finishedTasksLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var person: UIImageView!
    @IBOutlet weak var personConstraint: NSLayoutConstraint!
    var managedContext: NSManagedObjectContext!
    var userData: user!

    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageContext()
        retrieveData()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        
        percentLabel.text = String(userData.percent) + "%"
        finishedTasksLabel.text = String(userData.finished) + "/" + String(userData.all)
        
        self.personConstraint.constant = 300
        
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi - CGFloat.pi/2, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.init(named: "textColor")?.withAlphaComponent(0.3).cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = Double(userData.percent) / 100.0
        
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "")
        
        UIView.animate(withDuration: 4) {
            self.view.layoutSubviews()
        }
        
        
    }
    func manageContext() {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        managedContext = appDelegate.persistentContainer.viewContext
    }
    func retrieveData() {
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequestUser = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            
            let resultUser = try managedContext.fetch(fetchRequestUser) as? [NSManagedObject]
            
            let percent = resultUser![0].value(forKey: "percent") as! Int
            let finished = resultUser![0].value(forKey: "finished") as! Int
            let all = resultUser![0].value(forKey: "all") as! Int
            
            userData = user(percent: percent, finished: finished, all: all)
        } catch {
            
            print("Failed")
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
