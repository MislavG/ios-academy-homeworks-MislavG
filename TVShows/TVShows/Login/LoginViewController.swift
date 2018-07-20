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

class LoginViewController: HomeViewController {

    weak var delegate: ShowUserDelegate?
    
    var checkBoxState = false
    
    var user : User?
    var loginUser : LoginData?
    
    
    
    @IBOutlet weak var rememberMeCheckbox: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var eMailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
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
    
    @IBAction func createAccButtonPressed(_ sender: Any) {
        
        
        _alamofireCodableRegisterUserWith(email: eMailTextField.text!, password: passwordTextField.text!) //ne valja, popravit
        
    }
    @IBAction func logInButtonPressed(_ sender: Any) {

        _loginUserWith(email: eMailTextField.text!, password: passwordTextField.text!)
    }
    
    func OnLoginSuccess() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let homeViewController = storyboard.instantiateViewController(
            withIdentifier: "HomeViewController"
            ) as! HomeViewController
        
//        delegate = (homeViewController.self as! ShowUserDelegate)
//        delegate = self
        
        delegate?.showUser(info: (user?.email)!) //treba popravit
        
        navigationController?.pushViewController(homeViewController, animated:
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
//                    self?._infoLabel.text = "Success: \(user)"
                    self?.user = userTemp
                    print("Success: \(userTemp)")
                case .failure(let error):
//                    self?._infoLabel.text = "API failure: \(error)"
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
            .responseJSON { [weak self] dataResponse in
                
                switch dataResponse.result {
                case .success(let response):
//                    self?._infoLabel.text = "Success: \(response)"
                    self?.loginUser = response as? LoginData
                    print("Success: \(response)")
                    self?.OnLoginSuccess()
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(let error):
//                    self?._infoLabel.text = "API failure: \(error)"
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }
    //    private func hideActivityIndicator() {
//        activityIndicator.isHidden = true
//    }
    
    
    
}
