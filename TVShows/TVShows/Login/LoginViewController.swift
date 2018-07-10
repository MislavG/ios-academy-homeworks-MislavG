//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 09/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var numberOfTaps = 0
    
    @IBOutlet weak var numberOfTapsLabel: UILabel!
    
    @IBAction func buttonTap(_ sender: Any) {
        
        numberOfTaps+=1
        numberOfTapsLabel.text = String(numberOfTaps)
    }

}
