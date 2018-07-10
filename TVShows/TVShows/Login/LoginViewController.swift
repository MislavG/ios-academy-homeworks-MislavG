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
        viewStart()
    }
    
    var numberOfTaps = 0
    
    @IBOutlet weak var numberOfTapsLabel: UILabel!
    
    @IBAction func buttonTap(_ sender: Any) {
        
        numberOfTaps+=1
        numberOfTapsLabel.text = String(numberOfTaps)
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tapButton: UIButton!
    
    func hideActivityIndicator()
    {
        activityIndicator.isHidden = true
    }
    
    func viewStart() //on start, animate indicator for 3 seconds and activate button
    {
        activityIndicator.startAnimating()
        tapButton.isEnabled = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3) ) {
            self.activityIndicator.stopAnimating()
            self.tapButton.isEnabled = true
        }
    }
}
