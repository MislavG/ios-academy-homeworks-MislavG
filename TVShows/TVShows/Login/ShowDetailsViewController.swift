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
//            addNewButton.addTarget(self, action: "backAction", for: .touchUpInside)
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
    
        
        let addEpisodeViewController = storyboard.instantiateViewController(
            withIdentifier: "AddEpisodeViewController"
            ) as! AddEpisodeViewController
        
        
        addEpisodeViewController.loginUserData = self.loginUserData
        
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
 
    private func loadShowDetails(loginUserData: LoginData, showID : String) {
        _alamofireCodableGetShowDetails(loginUser: loginUserData, showID : showID)
    }
    
    private func loadEpisodes(loginUserData: LoginData, showID : String) {
        _alamofireCodableGetShowEpisodes(loginUser: loginUserData, showID : showID)
    }
    
    private func updateView() {
        showTitleLabel.text = showDetails?.title
        showDescriptionLabel.text = showDetails?.title
//        numberOfEpisodesLabel = showDetails.
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
//                    self?.tableView.reloadData()
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
        /*
         
         We have one section for testing purpose
         Usually it is the best to model your data simillar how you want them to
         show on screen.
         
         struct Section {
         let name: String
         let items: [Int]
         }
         
         .
         .
         .
         let sections: [Section]
         
         return sections.count
         
         */
        
        return 1
    }
    
    func tableView(_ episodesTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of rows
        return listOfEpisodes.count
    }
    
    func tableView(_ episodesTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        //        let number = _numbers[row]
        
        
        // `UITableViewCell` - as you can see, we are reusing ...
        let cell: DetailsTableViewCell = episodesTableView.dequeueReusableCell(
            withIdentifier: "DetailsTableViewCell",
            for: indexPath
            ) as! DetailsTableViewCell
        
        
        // Model data - which we will use for configuration of the view, in our case `UITableViewCell`
        let item: DetailsCellItem = DetailsCellItem(
            //            label: "INDEX PATH - ROW: \(row)",
            cellSeasonLabel: "S\(listOfEpisodes[row].season) Ep\(listOfEpisodes[row].episodeNumber)",
            cellEpisodeLabel: listOfEpisodes[row].title,
            cellColor: row % 2 == 0 ? .gray : .white
        )
        
        
        // Actuall configuration - we could of course just make all UI elements public, but that would be disgusting ;)
        cell.configure(with: item)
        
        
        // Here we are returning our resused and configured cell to be displayed on the screen.
        return cell
    }
    
//    func tableView(episodesTableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//
//        let showDetailsViewController = storyboard.instantiateViewController(
//            withIdentifier: "ShowDetailsViewController"
//            ) as! ShowDetailsViewController
//
//        showDetailsViewController.loginUserData = self.loginUserHome
//        showDetailsViewController.showID = listOfShows[indexPath.row].id
//        showDetailsViewController.loadViewIfNeeded()
//
//        navigationController?.setViewControllers([showDetailsViewController], animated:
//            true)
//
//    }
    
}

extension ShowDetailsViewController: UITableViewDelegate {
    
    /*
     Now, we are using autosizing via autolayout, if you want custom size override this function.
     And also, check other methods from `UITableViewDelegate`
     */
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 90
    //    }
}

extension ShowDetailsViewController: RefreshEpisodeListDelegate {
    func refreshEpisodeList() {
        
        loadEpisodes(loginUserData: loginUserData!, showID: showID!)
        self.episodesTableView.reloadData()
    }
}
