//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 16/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class HomeViewController: UIViewController {

    var text: String?
    var loginUserHome : LoginData?
    
    var show : Show?

    @IBOutlet weak var infoLabel: UILabel!
        
//        {
//        didSet {
//            infoLabel.text = text
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        _alamofireCodableGetShows(loginUser: loginUserHome!) //POPRAVIT
        // Do any additional setup after loading the view.
    }
    func loadShows(loginUserData: LoginData) {
        _alamofireCodableGetShows(loginUser: loginUserData)
    }
    
    private func _alamofireCodableGetShows(loginUser: LoginData) {
        SVProgressHUD.show()
        
        
//        let parameters: [String: String] = [
//            "email": email,
//            "password": password
//        ]
        
        
        let headers = ["Authorization": loginUser.token]
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Show]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
//                    self?.user = userTemp
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}

extension HomeViewController: ShowUserDelegate {
    func showUser(info: String) {
        infoLabel.text = info
    }
}
