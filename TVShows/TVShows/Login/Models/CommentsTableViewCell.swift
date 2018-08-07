//
//  CommentsTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit

struct CommentsCellItem {
    let cellUsername: String
    let cellColor: UIColor
    let cellImage: UIImage
    let cellComment: String
}

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
    }
    
    func configure(with item: CommentsCellItem) {
        backgroundColor = item.cellColor
        usernameLabel.text = item.cellUsername
        commentLabel.text = item.cellComment
        userImageView.image = item.cellImage

//        showImageView.kf.setImage(with: item.cellImageURL)
    }
}
