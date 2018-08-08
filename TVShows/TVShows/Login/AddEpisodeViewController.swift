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

class AddEpisodeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    weak var delegate: RefreshEpisodeListDelegate?
    
    var loginUserData : LoginData?
    
    var addEpisodeModel : AddEpisode?
    
    var showId: String!
    var mediaImage : Media?
    
    
    @IBOutlet private weak var episodeTitle: UITextField!
    @IBOutlet private weak var episodeSeason: UITextField!
    @IBOutlet private weak var episodeNumber: UITextField!
    @IBOutlet private weak var episodeDescription: UITextField!
    @IBOutlet weak var ulPhotoButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false,  animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard loginUserData != nil
            else {
                print("loginUserData not defined")
                return
        }
        
        title = "Add episode"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSelectAdd))
    }
    
    @IBAction func ulPhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //make small-sized image appear in button background
            uploadPhotoToServer(selectedImage: image, token: (loginUserData?.token)!)
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func uploadPhotoToServer(selectedImage: UIImage, token: String) {
        let headers = ["Authorization": token]
        
        let someUIImage = selectedImage
        let imageByteData = UIImagePNGRepresentation(someUIImage)!
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                } }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
//            .responseJSON { [weak self] dataResponse in
            .responseDecodableObject(keyPath: "data") { [weak self] (response:
                DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    print("DECODED: \(media)")
                    print("Proceed to add episode call...")
                    self?.mediaImage = media
                case .failure(let error):
                    print("FAILURE: \(error)")
                }
        }
    }

    @objc func didSelectCancel () {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAdd () {
        addEpisodeModel = AddEpisode.init(showId: showId, mediaId: mediaImage?.mediaId, title: episodeTitle.text!, description: episodeDescription.text!, episodeNumber: episodeNumber.text!, season: episodeSeason.text!)
    
        _alamofireCodableCreateNewEpisode(loginUser: loginUserData!, addEpisode: addEpisodeModel!)
    }
    
    private func onSuccess() {
        navigationController?.popViewController(animated: true)
        delegate?.refreshEpisodeList()
        dismiss(animated: true, completion: nil)
    }
    
    private func onFail() {
        let alertController = UIAlertController(title: "Alert", message: "Alert: Episode not created.", preferredStyle: .alert)
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        alertController.addAction(action2)
        present((alertController), animated: true, completion: nil)
    }
    
    private func _alamofireCodableCreateNewEpisode(loginUser: LoginData, addEpisode: AddEpisode) {
        SVProgressHUD.show()
        
                let parameters: [String: String] = [
                    "showId": addEpisode.showId!,
                    "mediaId": "KnhNCJGvczLiGDIC"/*addEpisode.mediaId!*/,
//                    "showId": addEpisode.showId!,
//                    "mediaId": addEpisode.mediaId!,
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
        
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let userTemp):
                    self?.onSuccess()
                    print("Success: \(userTemp)")
                case .failure(let error):
                    self?.onFail()
                    print("API failure: \(error)")
                }
        }
    }
}
