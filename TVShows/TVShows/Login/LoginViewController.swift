//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 09/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var checkBoxState = false
    
    
    @IBOutlet weak var rememberMeCheckbox: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var logInButton: UIButton!
    
    
    
    @IBAction func rememberMeCheckBoxPressed(_ sender: Any) {
        if (checkBoxState == false) {
            checkBoxState = true
            rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if (checkBoxState == true){
            checkBoxState = false
            rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-empty")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewStart()
    }
    
    //ctrl 6
    //MARK: -Private-
    private func viewStart() { //on start, animate indicator for 3 seconds and activate button
        
        logInButton.layer.cornerRadius = 7
    
        //activityIndicator.startAnimating()
        
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3) ) {
            //self.activityIndicator.stopAnimating()
        //}
    }
    
    private func hideActivityIndicator() {
        //activityIndicator.isHidden = true
    }
    
}
