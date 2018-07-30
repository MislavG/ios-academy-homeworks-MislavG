//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit

class AddEpisodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    
    @objc func didSelectAdd () {
        
    }
}
