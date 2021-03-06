//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 09/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol ShowUserDelegate: class {
    func showUser(info: String)
}


class LoginViewController: UIViewController {

    weak var delegate: ShowUserDelegate?
    
    var checkBoxState = false
    var user : User?
    var loginUser : LoginData?
    
    let alertController = UIAlertController(title: "Alert", message: "Alert: Login failed", preferredStyle: .alert)
    let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        print("You've pressed cancel");
    }

    let defaults = UserDefaults.standard
    let loginInfoKey = "loginInfo"
    
    
    
    enum MyError: Error {
        case runtimeError(String)
    }
    
    
    
    @IBOutlet weak var rememberMeCheckbox: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStart()
    }
    
    @IBAction func rememberMeCheckBoxPressed(_ sender: Any) {
        if !checkBoxState {
            checkBoxState = true
            rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        else if checkBoxState {
            checkBoxState = false
            rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-empty")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
 
    private func viewStart() {
        
        logInButton.layer.cornerRadius = 7
        
        self.alertController.addAction(self.action2)
        
        //check if user has stored credentials
        if defaults.object(forKey: loginInfoKey) != nil {
            let loginInfo: [String] = defaults.object(forKey: loginInfoKey) as! [String]
            _loginUserWith(email: loginInfo[0], password: loginInfo[1])
            
            checkBoxState = true
            rememberMeCheckBoxPressed(self)
        }
    }
    
    @IBAction func createAccButtonPressed(_ sender: Any) {
        
        guard
            _alamofireCodableRegisterUserWith(email: eMailTextField.text!, password: passwordTextField.text!) != nil else {
                    print("User registration fail")
                return
        }
    }
    @IBAction func logInButtonPressed(_ sender: Any) {

        guard eMailTextField.text! != ""
            else {
                eMailTextField.shake()
                eMailTextField.animateColorChangeAdvanced()
                print("Username is empty")
                return
        }
        guard passwordTextField.text! != ""
            else {
                passwordTextField.shake()
                passwordTextField.animateColorChangeAdvanced()
                print("Password is empty")
                return
        }
        
        _loginUserWith(email: eMailTextField.text!, password: passwordTextField.text!)
    }
    
    func onLoginSuccess() {
        
        //store in user defaults
        if checkBoxState {
            defaults.set([eMailTextField.text, passwordTextField.text], forKey: loginInfoKey)
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(
            withIdentifier: "HomeViewController"
            ) as! HomeViewController
        
        homeViewController.loginUserHome = self.loginUser
        homeViewController.loadViewIfNeeded()

        navigationController?.setViewControllers([homeViewController], animated:
            true)
    }
    
    private func _alamofireCodableRegisterUserWith(email: String, password: String) {
        SVProgressHUD.show()

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
                    self?.user = userTemp
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    private func _loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<LoginData>) in
        
                switch dataResponse.result {
                case .success(let response):
                    self?.loginUser = response
                    print("Success: \(response)")
                    self?.onLoginSuccess()
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.present((self?.alertController)!, animated: true, completion: nil )
                }
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func animateColorChangeAdvanced() {
        UIView.animate(
            withDuration: 0.5, delay: 0.0, options:[.autoreverse, .curveEaseInOut], animations: {
                self.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        }, completion: {(finished) in
            self.backgroundColor = UIColor.white.withAlphaComponent(1)})
    }
        
}
