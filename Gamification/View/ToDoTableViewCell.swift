//
//  ToDoTableViewCell.swift
//  Gamification
//
//  Created by Nurbek on 3/13/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var whatToDoLabel: UILabel!
    @IBOutlet weak var isDoneButton: UIButton!
    var object: NSManagedObject!
    var managedContext: NSManagedObjectContext!
    var hasLink: Bool?
    var i = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        print(isSelected)
        // Configure the view for the selected state
        if hasLink! {
            whatToDoLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
        else {
            whatToDoLabel.tintColor = UIColor.init(named: "textColor")
        }
    }
    
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        
        
        
        if sender.backgroundColor == UIColor.white {
            sender.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            object!.setValue(true, forKey: "isDone")
        }
        else {
            sender.backgroundColor = .white
            object!.setValue(false, forKey: "isDone")
        }
        do {
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
    }
    
}
