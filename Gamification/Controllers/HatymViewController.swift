//
//  HatymViewController.swift
//  Gamification
//
//  Created by Nurbek on 4/26/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

import UIKit

class HatymViewController: UIViewController {
    @IBOutlet weak var hatymDescriptionLable: UITextView!
    @IBOutlet weak var uaqytLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var uaqytView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        hatymDescriptionLable.layer.cornerRadius = 15
        uaqytView.layer.cornerRadius = 15
        acceptButton.layer.cornerRadius = 5
        denyButton.layer.cornerRadius = 5
        finishButton.layer.cornerRadius = 5
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
