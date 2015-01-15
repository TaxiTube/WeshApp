//
//  WallPostTableViewCell.swift
//  WeshApp
//
//  Created by rabzu on 25/12/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

class WallPostTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var wallPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
