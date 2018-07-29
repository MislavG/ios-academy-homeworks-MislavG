//
//  DetailsTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 29/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import UIKit

struct DetailsCellItem {
    let cellSeasonLabel: String
    let cellEpisodeLabel: String
    let cellColor: UIColor
}

class DetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var seasonLabel: UILabel!
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
    }
    
    func configure(with item: DetailsCellItem) {
        backgroundColor = item.cellColor
        seasonLabel.text = item.cellSeasonLabel
        episodeTitleLabel.text = item.cellEpisodeLabel

    }
    
}
