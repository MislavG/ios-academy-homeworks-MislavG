//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 09/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var numberOfTapsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tapButton: UIButton!
    
    private var numberOfTaps = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewStart()
    }
    
    //ctrl 6
    //MARK: -Private-
    private func viewStart() { //on start, animate indicator for 3 seconds and activate button
    
        activityIndicator.startAnimating()
        tapButton.isEnabled = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3) ) {
            self.activityIndicator.stopAnimating()
            self.tapButton.isEnabled = true
        }
    }
    
    private func hideActivityIndicator() {
        activityIndicator.isHidden = true
    }
    
    
    
    @IBAction func buttonTap(_ sender: Any) {
        
        numberOfTaps += 1
        numberOfTapsLabel.text = String(numberOfTaps)
    }
}
