//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol RefreshEpisodeListDelegate: class {
    func refreshEpisodeList()
}

class AddEpisodeViewController: UIViewController {

    weak var delegate: RefreshEpisodeListDelegate?
    
    var loginUserData : LoginData?
    
    var addEpisodeModel : AddEpisode?
    
    let alertController = UIAlertController(title: "Alert", message: "Alert: Episode not created.", preferredStyle: .alert)
    
    let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        print("You've pressed cancel");
    }
    
    @IBOutlet private weak var episodeTitle: UITextField!
    @IBOutlet private weak var episodeSeason: UITextField!
    @IBOutlet private weak var episodeNumber: UITextField!
    @IBOutlet private weak var episodeDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertController.addAction(self.action2)
        
        guard loginUserData != nil
            else {
                print("loginUserData not defined")
                return
        }

        self.title = "Add episode"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectAdd))
        

    }

    @objc func didSelectCancel () {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAdd () {
        addEpisodeModel = AddEpisode.init(showId: nil, mediaId: nil, title: episodeTitle.text!, description: episodeDescription.text!, episodeNumber: episodeNumber.text!, season: episodeSeason.text!)
    
        _alamofireCodableCreateNewEpisode(loginUser: loginUserData!, addEpisode: addEpisodeModel!)
    }
    
    private func onSuccess() {
        navigationController?.popViewController(animated: true)
        delegate?.refreshEpisodeList()
        dismiss(animated: true, completion: nil)
    }
    
    private func onFail() {
        self.present((self.alertController), animated: true, completion: nil)
    }
    
    private func _alamofireCodableCreateNewEpisode(loginUser: LoginData, addEpisode: AddEpisode) {
        SVProgressHUD.show()
        
                let parameters: [String: String] = [
                    "showId": "KnhNCJGvczXiGLIC"/*addEpisode.showId!*/,
                    "mediaId": "KnhNCJGvczLiGDIC"/*addEpisode.mediaId!*/,
                    "title": addEpisode.title,
                    "description": addEpisode.description,
                    "episodeNumber": addEpisode.episodeNumber,
                    "season": addEpisode.season
                ]
        
        let headers = ["Authorization": loginUser.token]
        Alamofire
            .request("https://api.infinum.academy/api/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseJSON { [weak self] dataResponse in
                
//            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<Any>) in
        
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
//                    self?.showDetails = userTemp
                    self?.onSuccess()
                    //                    self?.tableView.reloadData()
//                    self?.updateView()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    self?.onFail()
                    print("API failure: \(error)")
                }
        }
    }
}
