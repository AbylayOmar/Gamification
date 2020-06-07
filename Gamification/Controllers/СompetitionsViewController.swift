//
//  СompetitionsViewController.swift
//  Gamification
//
//  Created by Nurbek on 3/27/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit
import CoreData

class CompetitionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var managedContext: NSManagedObjectContext!
    var challengeList: [NSManagedObject]!
    
    //var challengeList = [ChallengeModel.init(name: "Ramazan 30 day challenge", state: "Тегін", ratingForStars: "4.5", rating: "192/201", price: "Тегін")]
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 172, height: 172)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeList.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! ChallengeCollectionViewCell
        cell.widthAnchor.constraint(equalToConstant: 172).isActive = true
        cell.heightAnchor.constraint(equalToConstant: 172).isActive = true
        cell.title.text = challengeList[indexPath.row].value(forKey: "name") as? String
        cell.price.text = challengeList[indexPath.row].value(forKey: "price") as? String
        
        cell.state.layer.cornerRadius = 17.5
        cell.state.layer.masksToBounds = true
        if (challengeList[indexPath.row].value(forKey: "state") as? String) == "null" {
            cell.state.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webViewController = self.storyboard!.instantiateViewController(withIdentifier: "webVC") as! WebViewController
        webViewController.header = self.challengeList[indexPath.row].value(forKey: "name") as? String
        print((self.challengeList[indexPath.row].value(forKey: "url") as! String))
        webViewController.link = (self.challengeList[indexPath.row].value(forKey: "url") as! String)
        
        self.present(webViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manageContext()
        retrieveData()
        // Do any additional setup after loading the view.
    }
    
    func manageContext() {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        managedContext = appDelegate.persistentContainer.viewContext
    }
    func retrieveData() {
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequestChallenge = NSFetchRequest<NSFetchRequestResult>(entityName: "Challenge")
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            
            challengeList = try managedContext.fetch(fetchRequestChallenge) as? [NSManagedObject]
            
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
