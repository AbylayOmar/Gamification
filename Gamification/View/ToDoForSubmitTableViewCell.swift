//
//  toDoForTableViewCell.swift
//  Gamification
//
//  Created by Nurbek on 5/3/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit
import CoreData

class ToDoForSubmitTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var object: NSManagedObject!
    var managedContext: NSManagedObjectContext!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
