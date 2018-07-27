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
    var listOfShows : [Show]?

    private let _numbers = Array(1...1000)
    
    @IBOutlet weak var infoLabel: UILabel!
        
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    //        {
//        didSet {
//            infoLabel.text = text
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return listOfShows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = indexPath.row
        let number = _numbers[row]
        
        
        // `UITableViewCell` - as you can see, we are reusing ...
        let cell: HomeTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "HomeTableViewCell",
            for: indexPath
            ) as! HomeTableViewCell
        
        
        // Model data - which we will use for configuration of the view, in our case `UITableViewCell`
        let item: IndexPathCellItem = IndexPathCellItem(
//            label: "INDEX PATH - ROW: \(row)",
            label: listOfShows?[row].title ?? "nil",
            color: row % 2 == 0 ? .blue : .white
        )
        
        
        // Actuall configuration - we could of course just make all UI elements public, but that would be disgusting ;)
        cell.configure(with: item)
        
        
        // Here we are returning our resused and configured cell to be displayed on the screen.
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//        println(tasks[indexPath.row])
//        
//    }
    
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
