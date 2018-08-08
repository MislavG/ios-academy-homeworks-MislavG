//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class CommentsViewController: UIViewController {

    
    var loginUserData : LoginData?
    var episodeID : String?
    var episodeComments : [Comment] = []
    
    @IBOutlet private weak var commentTextField: UITextField! {
        didSet {
            commentTextField.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,  animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        title = "Comments"
        let image = UIImage(named: "ic-navigate-back")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectBack))
        
        guard loginUserData != nil
            else {
                print("loginUserData not defined")
                return
        }
        
        guard episodeID != nil
            else {
                print("episodeID not defined")
                return
        }
        _alamofireCodableGetComments(loginUser: loginUserData!, episodeID : episodeID!)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        guard loginUserData != nil
            else {
                print("loginUserData not defined")
                return
        }
        guard commentTextField.text != ""
            else {
                print("comment empty")
                return
        }
        guard episodeID != nil
            else {
                print("episodeID not defined")
                return
        }
        postCommentToServer(text: commentTextField.text!, episodeId: episodeID!,  token: (loginUserData?.token)!)
    }
    
    
    
    @objc func didSelectBack () {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func postCommentToServer(text: String, episodeId: String, token: String) {
        
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        
        let parameters: [String: String] = [
            "text" : text,
            "episodeId" : episodeId
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/comments",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseJSON { [weak self] dataResponse in
        
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
                    self?._alamofireCodableGetComments(loginUser: (self?.loginUserData!)!, episodeID : (self?.episodeID!)!)
                    self?.tableView.reloadData()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    private func _alamofireCodableGetComments(loginUser: LoginData, episodeID: String) {
        SVProgressHUD.show()
        
        //{"text":"Ovo mi je skola","episodeId":"9dU0Vte9h9GTPNDb","userEmail":"jakov.vidak@gmail.com","_id":"In0aWXzbQ04HsFKg"}
        let headers = ["Authorization": loginUser.token]
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episodeID)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Comment]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
                    self?.episodeComments = userTemp
                    self?.tableView.reloadData()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}
extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        let cell: CommentsTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "CommentsTableViewCell",
            for: indexPath
            ) as! CommentsTableViewCell
    
 
        let item: CommentsCellItem = CommentsCellItem(
            cellUsername: episodeComments[row].userEmail,
            cellColor: row % 2 == 0 ? .gray : .white,
            cellImage: UIImage.init(named: "img-placeholder-user1")!, //FIX
            cellComment: episodeComments[row].text
        )
            
        cell.configure(with: item)
        
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate {
    
}
