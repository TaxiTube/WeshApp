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
    var fetchedResultsController : NSFetchedResultsController!
    var coreDataStack: CoreDataStack!
    let screenSize  = UIScreen.mainScreen().bounds.size
    
        @IBOutlet weak var descriptionLabel: UILabel!
//        @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

                descriptionLabel.preferredMaxLayoutWidth = screenSize.width
//                channelTitle.text = channel?.author.handle
                descriptionLabel.text = channel?.desc
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
