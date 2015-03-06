//
//  ChannelHeaderVC.swift
//  WeshApp
//
//  Created by rabzu on 22/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
import CoreData



class ChannelHeaderVC: UIViewController {
    
    var channel: Channel?
    let screenSize  = UIScreen.mainScreen().bounds.size
    
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.preferredMaxLayoutWidth = screenSize.width
        handle.text = "#\(channel!.author.handle)"
        descriptionLabel.text = channel?.desc
//        if let firstname = channel?.author.profile.firstName {
//            nameLabel.text = "\(firstname) \(channel?.author.profile.lastName)"
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
