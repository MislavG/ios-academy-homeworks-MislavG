//
//  HomeTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit

struct IndexPathCellItem {
    let cellTitleLabel: String
    let cellColor: UIColor
}

class HomeTableViewCell: UITableViewCell {
    
//    @IBOutlet private weak var _leftLabel: UILabel!
//    @IBOutlet private weak var _rightLabel: UILabel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        /// You want to use this method for reseting the view to its originall state
        /// If you remember, we are reusing `UITableViewCell's`
        
//        _leftLabel.text = nil
//        _rightLabel.text = nil
        titleLabel.text = nil
    }
    
    func configure(with item: IndexPathCellItem) {
        backgroundColor = item.cellColor
//        _leftLabel.text = item.left
//        _rightLabel.text = item.right
        titleLabel.text = item.cellTitleLabel
    }
    
}

