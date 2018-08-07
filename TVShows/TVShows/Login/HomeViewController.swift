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

    private var text: String?
    var loginUserHome : LoginData?
    
    private var show : Show?
    private var listOfShows: [Show] = []
  
    @IBOutlet weak var infoLabel: UILabel!
        
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shows"
        guard loginUserHome != nil
            else {
                print("loginUserHome not defined")
                return
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic-logout"),
                                                           style: .plain,
                                                           target: self,
                                                           action:
            #selector(_logoutActionHandler))
        
        loadShows(loginUserData: loginUserHome!)
    }
    
    @objc private func _logoutActionHandler() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
            ) as! LoginViewController
        
        UserDefaults.standard.removeObject(forKey: "loginInfo")
        
        navigationController?.setViewControllers([loginViewController],
                                                 animated: true)
    }
    

    
    func loadShows(loginUserData: LoginData) {
        _alamofireCodableGetShows(loginUser: loginUserData)
    }
    
    private func _alamofireCodableGetShows(loginUser: LoginData) {
        SVProgressHUD.show()
        
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
                    self?.listOfShows = userTemp
                    self?.tableView.reloadData()
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

extension HomeViewController: UITableViewDataSource {
    
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
        
        
        let url = URL(string: "https://api.infinum.academy" + listOfShows[row].imageUrl)

        // Model data - which we will use for configuration of the view, in our case `UITableViewCell`
        let item: IndexPathCellItem = IndexPathCellItem(
//            label: "INDEX PATH - ROW: \(row)",
            cellTitleLabel: listOfShows[row].title,
            cellColor: row % 2 == 0 ? .gray : .white,
            cellImageURL: url!
//            cellImage: UIImageView.kf.setImage(with: url)
        )
        
        
        // Actuall configuration - we could of course just make all UI elements public, but that would be disgusting ;)
        cell.configure(with: item)
        
        // Here we are returning our resused and configured cell to be displayed on the screen.
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ShowDetailsViewController"
            ) as! ShowDetailsViewController
        
        showDetailsViewController.loginUserData = self.loginUserHome
        showDetailsViewController.showID = listOfShows[indexPath.row].id
        showDetailsViewController.loadViewIfNeeded()
        
        navigationController?.pushViewController(showDetailsViewController, animated:
            true)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    /*
     Now, we are using autosizing via autolayout, if you want custom size override this function.
     And also, check other methods from `UITableViewDelegate`
     */
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 90
    //    }
}
