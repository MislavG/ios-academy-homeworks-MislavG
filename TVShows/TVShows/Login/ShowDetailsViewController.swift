//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 29/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import Kingfisher

class ShowDetailsViewController: UIViewController {

    var loginUserData : LoginData?
    var showID : String?
    
    private var showDetails : ShowDetails?
    private var listOfEpisodes : [Episode] = []
    
    @IBOutlet private weak var showImageView: UIImageView!
    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var numberOfEpisodesLabel: UILabel!
    
    @IBOutlet private weak var addNewButton: UIButton! {
        didSet {
            addNewButton.layer.shadowColor = UIColor.black.cgColor
            addNewButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            addNewButton.layer.masksToBounds = false
            addNewButton.layer.shadowRadius = 2.0
            addNewButton.layer.shadowOpacity = 0.5
            addNewButton.layer.cornerRadius = addNewButton.frame.width / 2
        }
    }
    @IBOutlet private weak var backButton: UIButton!  {
        didSet {
            backButton.layer.shadowColor = UIColor.black.cgColor
            backButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            backButton.layer.masksToBounds = false
            backButton.layer.shadowRadius = 2.0
            backButton.layer.shadowOpacity = 0.5
            backButton.layer.cornerRadius = backButton.frame.width / 2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard loginUserData != nil
            else {
                print("loginUserData not defined")
                return
        }
        loadShowDetails(loginUserData: loginUserData!, showID: showID!)
        loadEpisodes(loginUserData: loginUserData!, showID: showID!)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
    
        let addEpisodeViewController = storyboard.instantiateViewController(
            withIdentifier: "AddEpisodeViewController"
            ) as! AddEpisodeViewController
        
        
        addEpisodeViewController.loginUserData = self.loginUserData
        addEpisodeViewController.showId = showID!
        let navigationController = UINavigationController.init(rootViewController:
            addEpisodeViewController)
        
        addEpisodeViewController.loadViewIfNeeded()
        addEpisodeViewController.delegate = self
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBOutlet private weak var episodesTableView: UITableView! {
        didSet {
            episodesTableView.dataSource = self
            episodesTableView.delegate = self
        }
    }
 
    private func loadShowDetails(loginUserData: LoginData, showID : String) {
        _alamofireCodableGetShowDetails(loginUser: loginUserData, showID : showID)
    }
    
    private func loadEpisodes(loginUserData: LoginData, showID : String) {
        _alamofireCodableGetShowEpisodes(loginUser: loginUserData, showID : showID)
    }
    
    private func updateView() {
        showTitleLabel.text = showDetails?.title
        showDescriptionLabel.text = showDetails?.title
    }
    
    private func updateEpisodeNumber() {
        numberOfEpisodesLabel.text = String(listOfEpisodes.count)
    }
    
    private func _alamofireCodableGetShowDetails(loginUser: LoginData, showID: String) {
        SVProgressHUD.show()
    

        let headers = ["Authorization": loginUser.token]
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showID)",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<ShowDetails>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
                    self?.showDetails = userTemp
                     let url = URL(string: "https://api.infinum.academy" + userTemp.imageUrl)
                    self?.showImageView.kf.setImage(with: url)
                    self?.updateView()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    private func _alamofireCodableGetShowEpisodes(loginUser: LoginData, showID: String) {
        SVProgressHUD.show()
        
        
        let headers = ["Authorization": loginUser.token]
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showID)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Episode]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
                    self?.listOfEpisodes = userTemp
                    self?.episodesTableView.reloadData()
                    self?.updateEpisodeNumber()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }

}
extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in episodesTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ episodesTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of rows
        return listOfEpisodes.count
    }
    
    func tableView(_ episodesTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row

        let cell: DetailsTableViewCell = episodesTableView.dequeueReusableCell(
            withIdentifier: "DetailsTableViewCell",
            for: indexPath
            ) as! DetailsTableViewCell
        
        let item: DetailsCellItem = DetailsCellItem(
            cellSeasonLabel: "S\(listOfEpisodes[row].season) Ep\(listOfEpisodes[row].episodeNumber)",
            cellEpisodeLabel: listOfEpisodes[row].title,
            cellColor: row % 2 == 0 ? .gray : .white
        )
        
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let episodeDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "EpisodeDetailsViewController"
            ) as! EpisodeDetailsViewController
        
        episodeDetailsViewController.loginUserData = self.loginUserData
        episodeDetailsViewController.episodeID = listOfEpisodes[indexPath.row].id
        episodeDetailsViewController.loadViewIfNeeded()
        
        navigationController?.pushViewController(episodeDetailsViewController, animated:
            true)
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    
}

extension ShowDetailsViewController: RefreshEpisodeListDelegate {
    func refreshEpisodeList() {
        
        loadEpisodes(loginUserData: loginUserData!, showID: showID!)
        self.episodesTableView.reloadData()
    }
}
