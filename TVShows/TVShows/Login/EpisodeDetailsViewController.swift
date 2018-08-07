//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import Kingfisher

class EpisodeDetailsViewController: UIViewController {

    var loginUserData : LoginData?
    var episodeID : String?
    
    private var episodeDetails : Episode?
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    @IBOutlet weak var episodeCommentsButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.layer.shadowColor = UIColor.black.cgColor
            backButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            backButton.layer.masksToBounds = false
            backButton.layer.shadowRadius = 2.0
            backButton.layer.shadowOpacity = 0.5
            backButton.layer.cornerRadius = backButton.frame.width / 2
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        guard loginUserData != nil
            else {
                print("loginUserData not defined")
                return
        }
        loadEpisodeDetails(loginUserData: loginUserData!, episodeID: episodeID!)

    }
    
    private func loadEpisodeDetails(loginUserData: LoginData, episodeID : String) {
        _alamofireCodableGetEpisodeDetails(loginUser: loginUserData, episodeID : episodeID)
    }
    
    private func updateView() {
        episodeNameLabel.text = episodeDetails?.title
        episodeDescriptionLabel.text = episodeDetails?.description
        episodeNumberLabel.text = "S\(episodeDetails?.season ?? "0") Ep\(episodeDetails?.episodeNumber ?? "0")"
    }
    
    private func _alamofireCodableGetEpisodeDetails(loginUser: LoginData, episodeID: String) {
        SVProgressHUD.show()
        
        
        let headers = ["Authorization": loginUser.token]
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episodeID)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<Episode>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
                    self?.episodeDetails = userTemp
                    //                    self?.tableView.reloadData()
                    let url = URL(string: "https://api.infinum.academy" + userTemp.imageUrl)
                    self?.episodeImageView.kf.setImage(with: url)
                    self?.updateView()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }

}
