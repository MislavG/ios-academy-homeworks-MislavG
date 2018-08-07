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
    
    var mediaImage : Media?
    
    let alertController = UIAlertController(title: "Alert", message: "Alert: Episode not created.", preferredStyle: .alert)
    
    let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        print("You've pressed cancel");
    }
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet private weak var episodeTitle: UITextField!
    @IBOutlet private weak var episodeSeason: UITextField!
    @IBOutlet private weak var episodeNumber: UITextField!
    @IBOutlet private weak var episodeDescription: UITextField!
//    @IBOutlet private weak var ULPhotoImageView: UIImageView!
    @IBOutlet weak var ULPhotoButton: UIButton!
    
    @IBAction func ULPhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //make small-sized image appear in button background
//            ULPhotoButton.setBackgroundImage(image, for: UIControlState.normal)
//            ULPhotoButton.setImage(image, for: .normal)
//            ULPhotoButton.image
//            ULPhotoButton.imageView?.image = image
//            ULPhotoButton.imageView?.contentMode = .scaleAspectFit
//            imageView.image = image
            uploadPhotoToServer(selectedImage: image, token: (loginUserData?.token)!)
        }
        
        picker.dismiss(animated: true, completion: nil);
        
//        ULPhotoButton.setBackgroundImage(image, for: UIControlState.normal)
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
            .responseDecodableObject(keyPath: "data") { (response:
                DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    print("DECODED: \(media)")
                    print("Proceed to add episode call...")
                    self.mediaImage = media
                case .failure(let error):
                    print("FAILURE: \(error)")
                }
        }
    }
    
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
        addEpisodeModel = AddEpisode.init(showId: nil, mediaId: mediaImage?.mediaId, title: episodeTitle.text!, description: episodeDescription.text!, episodeNumber: episodeNumber.text!, season: episodeSeason.text!)
    
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
