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

class ShowDetailsViewController: UIViewController {

    var loginUserData : LoginData?
    var showID : String?
    
    private var showDetails : ShowDetails?
    private var episodes : [Episode] = []
    
    @IBOutlet private weak var showImageView: UIImageView!
    @IBOutlet private weak var showNameLabel: UILabel!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var numberOfEpisodesLabel: UILabel!
    
    @IBOutlet weak var episodesTableView: UITableView! {
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
 
    func loadShowDetails(loginUserData: LoginData, showID : String) {
        _alamofireCodableGetShowDetails(loginUser: loginUserData, showID : showID)
    }
    
    func loadEpisodes(loginUserData: LoginData, showID : String) {
        _alamofireCodableGetShowEpisodes(loginUser: loginUserData, showID : showID)
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
                    self?.episodes = userTemp
//                    self?.tableView.reloadData()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }

}
extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of rows
        return listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        //        let number = _numbers[row]
        
        
        // `UITableViewCell` - as you can see, we are reusing ...
        let cell: HomeTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "HomeTableViewCell",
            for: indexPath
            ) as! HomeTableViewCell
        
        
        // Model data - which we will use for configuration of the view, in our case `UITableViewCell`
        let item: IndexPathCellItem = IndexPathCellItem(
            //            label: "INDEX PATH - ROW: \(row)",
            cellTitleLabel: listOfShows[row].title,
            cellColor: row % 2 == 0 ? .blue : .white
        )
        
        
        // Actuall configuration - we could of course just make all UI elements public, but that would be disgusting ;)
        cell.configure(with: item)
        
        
        // Here we are returning our resused and configured cell to be displayed on the screen.
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ShowDetailsViewController"
            ) as! ShowDetailsViewController
        
        showDetailsViewController.loginUserData = self.loginUserHome
        showDetailsViewController.showID = listOfShows[indexPath.row].id
        showDetailsViewController.loadViewIfNeeded()
        
        navigationController?.setViewControllers([showDetailsViewController], animated:
            true)
        
    }
    
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
