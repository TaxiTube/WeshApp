//
//  ChannelTableViewCell.swift
//  WeshApp
//
//  Created by rabzu on 05/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
import Designables

protocol ChannelTableViewCellProtocol{
    //when paus action is pressed perform channel pause
    func pauseAction()
}
class ChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var totem: UIImageView!
    @IBOutlet weak var title: WeshappLabel!
    @IBOutlet weak var subTitle: WeshappLabel!
    @IBOutlet weak var counter: NSLayoutConstraint!
    
    var delegate: ChannelTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.setEditing(true, animated: true)// = UITableViewCellEditingStyle.Delete
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
